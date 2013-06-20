#!/usr/bin/env python
#==============================================================================
# Copyright 2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#       http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions
# and limitations under the License.
#==============================================================================

import re
import logging

from lib.elasticbeanstalk.request import TemplateSpecification
from lib.utility import misc, shell_utils
from scli import api_wrapper
from scli.constants import DevToolsEndpoint, DevToolsDefault, DefaultAppSource, \
    KnownAppContainers, OptionSettingVPC, ParameterName as PName, \
    ParameterSource as PSource, ServiceDefault, ServiceEndpoint
from scli.parameter import Parameter
from scli.resources import DevToolsMessage
from scli.terminal.base import TerminalBase


log = logging.getLogger('eb')


def match_solution_stack(solution_stack):
    for container in KnownAppContainers:
        if re.match(container.Regex, solution_stack, re.UNICODE):
            return container.Name
    return None


def generate_endpoint(parameter_pool, region, source, force = False):
    parameter_pool.put(Parameter(PName.ServiceEndpoint, 
                                 ServiceEndpoint[region], 
                                 source))     
    parameter_pool.put(Parameter(PName.DevToolsEndpoint, 
                                 DevToolsEndpoint[region], 
                                 source))      


def has_default_app(parameter_pool, solution_stack, eb_client = None):
    appsource_options = {DefaultAppSource.Namespace : {DefaultAppSource.OptionName}}
    
    spec = TemplateSpecification()
    spec.template_source.solution_stack_name = solution_stack,     
    
    options = api_wrapper.retrieve_configuration_options(parameter_pool, 
                                            solution_stack = solution_stack,
                                            options = appsource_options,
                                            template_specification = spec,
                                            eb_client = eb_client)
    for option in options:
        if misc.string_equal_ignore_case(DefaultAppSource.Namespace, option.namespace) \
            and misc.string_equal_ignore_case(DefaultAppSource.OptionName, option.name):
            return True
        
    return False


def trim_vpc_options(option_settings, option_to_remove):
    if OptionSettingVPC.Namespace in option_settings\
        and OptionSettingVPC.MagicOptionName in option_settings[OptionSettingVPC.Namespace]\
        and not misc.is_blank_string(option_settings[OptionSettingVPC.Namespace]\
                                     [OptionSettingVPC.MagicOptionName]):
        # VPC enabled
        for namespace in OptionSettingVPC.TrimOption:
            for option in OptionSettingVPC.TrimOption[namespace]:
                remove_option_setting(option_settings, option_to_remove, namespace, option)
    else:
        # VPC disabled
        remove_option_namespace(option_settings, option_to_remove, OptionSettingVPC.Namespace)


def check_app_version(parameter_pool, eb_client = None):
    #TODO: Do we need to blast version info away if this part is strong enough?
    if not parameter_pool.has(PName.ApplicationVersionName) \
        or parameter_pool.get_source(PName.ApplicationVersionName) == PSource.Default:

        version_name = get_head_version(parameter_pool, eb_client=eb_client, quiet=True)        
        
        if version_name is not None:
            log.info('Found a version from local repository: {0}. Using this version.'.\
                     format(version_name))
            return version_name
        else:
            # Otherwise try push a new one
            if not parameter_pool.get_value(PName.Force) == ServiceDefault.ENABLED\
                and not TerminalBase.ask_confirmation(DevToolsMessage.PushLocalHead):
                return ServiceDefault.DEFAULT_VERSION_NAME
            else:
                if shell_utils.git_aws_push(False):
                    version_name = get_head_version(parameter_pool, 
                                                    eb_client=eb_client, 
                                                    quiet=False)
                    if version_name:
                        return version_name   
                return ServiceDefault.DEFAULT_VERSION_NAME
    else:
        # Verify existence of version
        app_name = parameter_pool.get_value(PName.ApplicationName, False)
        version_names = api_wrapper.get_all_versions(parameter_pool, app_name, eb_client)
        version_name = parameter_pool.get_value(PName.ApplicationVersionName)    
        if version_name in version_names:
            # Assume version is still valid and compatible with current solution stack
            return version_name
        else:
            # 
            return ServiceDefault.DEFAULT_VERSION_NAME


def get_head_version(parameter_pool, eb_client = None, quiet = True):
    # Get all versions
    app_name = parameter_pool.get_value(PName.ApplicationName, False)
    version_names = api_wrapper.get_all_versions(parameter_pool, app_name, eb_client)

    # Try get local commit HEAD hash
    head_hash = shell_utils.get_repo_head_hash(quiet)
    if head_hash is None:
        return ServiceDefault.DEFAULT_VERSION_NAME
    
    # Try find a version corresponding to local HEAD
    version_re = re.compile(DevToolsDefault.VersionNameRe.format(head_hash),re.UNICODE)
    timestamp = 0
    for version in version_names:
        if version_re.match(version):
            cur_timestamp = int(version.split(DevToolsDefault.NameDelimiter)[2])
            timestamp = cur_timestamp if cur_timestamp > timestamp else timestamp
    
    if timestamp > 0:
        # Found a version generated from local repos HEAD
        log.info('Found a version generated from local HEAD {0}. Using this version.'.\
                 format(head_hash))
        return DevToolsDefault.VersionNameMask.format(head_hash, timestamp)
    else:
        return None


# Add/update an option setting of specified value to option setting dict        
def add_option_setting(option_settings, option_remove, namespace, option, value):
    if namespace not in option_settings:
        option_settings[namespace] = dict()
    option_settings[namespace][option] = value
    
    if namespace in option_remove and option in option_remove[namespace]:
        option_remove[namespace].remove(option)


# Remove an option setting from option setting dict        
def remove_option_setting(option_settings, option_remove, 
                          namespace, option, add_to_remove = True):
    if namespace in option_settings and option in option_settings[namespace]:
        del option_settings[namespace][option]

    if add_to_remove:
        if namespace not in option_remove:
            option_remove[namespace] = set()
        option_remove[namespace].add(option)


# Remove an entire option namespace from option setting dict     
def remove_option_namespace(option_settings, option_remove, 
                            namespace, add_to_remove = True):
    if namespace in option_settings:
        for option, _ in list(option_settings[namespace].items()):
            remove_option_setting(option_settings, option_remove, 
                                  namespace, option, add_to_remove)
        del option_settings[namespace]

