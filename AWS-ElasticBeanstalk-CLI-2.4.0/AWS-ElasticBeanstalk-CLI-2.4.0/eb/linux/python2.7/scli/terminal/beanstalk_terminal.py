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
import os
import re

from lib.utility import shell_utils, misc
from scli import api_wrapper, config_file, prompt
from scli.constants import EbLocalDir, OptionSettingFile, ParameterSource, \
    ParameterName, ServiceDefault
from scli.terminal.iam_terminal import IamTerminal 
from scli.terminal.rds_terminal import RdsTerminal 
from scli.terminal.base import TerminalBase
from scli.resources import TerminalMessage, TerminalPromptAskingMessage, \
    TerminalPromptSettingParameterMessage
from scli.parameter import Parameter


class BeanstalkTerminal(TerminalBase):

    @classmethod
    def ask_application_name(cls, parameter_pool):
        if not parameter_pool.has(ParameterName.ApplicationName):
            app_name = shell_utils.get_current_dir_name()
            cls.ask_parameter(parameter_pool, 
                               ParameterName.ApplicationName,
                               autogen_value = app_name)
        else:
            cls.ask_parameter(parameter_pool, ParameterName.ApplicationName)            
        

    @classmethod
    def ask_environment_name(cls, parameter_pool):
        # Auto generate environment name if not specified by user
        if not parameter_pool.has(ParameterName.EnvironmentName):
            old_env_name = None
            app_name = parameter_pool.get_value(ParameterName.ApplicationName, False)
            env_name = cls.generate_env_name(app_name)
            cls.ask_parameter(parameter_pool, 
                               ParameterName.EnvironmentName,
                               autogen_value = env_name)
        else:
            old_env_name = parameter_pool.get_value(ParameterName.EnvironmentName, False)
            cls.ask_parameter(parameter_pool, ParameterName.EnvironmentName)            
    
        # Post processing
        new_env_name = parameter_pool.get_value(ParameterName.EnvironmentName, False)
        new_env_source = parameter_pool.get_source(ParameterName.EnvironmentName)
        
        # Reload RDS password if environment name changes
        if old_env_name != new_env_name:
            location = parameter_pool.get_value(ParameterName.AwsCredentialFile)
            rds_password = config_file.read_rds_master_password(new_env_name, location)
            if rds_password:
                parameter_pool.put(Parameter(ParameterName.RdsMasterPassword,
                                             rds_password,
                                             new_env_source))
            else:
                parameter_pool.remove(ParameterName.RdsMasterPassword)
    
        # Generate option setting file pathname
        if parameter_pool.get_source(ParameterName.OptionSettingFile) == ParameterSource.Default\
            or not misc.string_equal_ignore_case(old_env_name, new_env_name):
            new_opsetting_path = os.path.join(os.getcwdu(), EbLocalDir.Path, 
                                           OptionSettingFile.Name + u'.' + new_env_name)
            old_opsetting_path = parameter_pool.get_value(ParameterName.OptionSettingFile, False)
            
            # Rename old style optionsetting file 
            if parameter_pool.get_source(ParameterName.OptionSettingFile) == ParameterSource.Default\
                and parameter_pool.has(ParameterName.OriginalSolutionStack)\
                and old_opsetting_path and os.path.exists(old_opsetting_path):
                os.rename(old_opsetting_path, new_opsetting_path)

            # Update optionsetting file name in parameter pool                
            parameter_pool.put(Parameter(ParameterName.OptionSettingFile,
                                         new_opsetting_path,
                                         new_env_source))


    @classmethod
    def ask_branch_environment_name(cls, parameter_pool):
        # Auto generate environment name if not specified by user
        if not parameter_pool.has(ParameterName.EnvironmentName):
            old_env_name = None
            app_name = parameter_pool.get_value(ParameterName.ApplicationName, False)
            current_branch = parameter_pool.get_value(ParameterName.CurrentBranch, False)
            env_name = cls.generate_env_name(app_name \
                                             + ServiceDefault.Environment.BRANCH_NAME_SEPERATOR\
                                             + current_branch)
            cls.ask_parameter(parameter_pool, 
                               ParameterName.EnvironmentName,
                               autogen_value = env_name)
        else:
            old_env_name = parameter_pool.get_value(ParameterName.EnvironmentName, False)
            cls.ask_parameter(parameter_pool, ParameterName.EnvironmentName)            
    
        # Generate option setting file pathname
        new_env_name = parameter_pool.get_value(ParameterName.EnvironmentName, False)
        if not misc.string_equal_ignore_case(old_env_name, new_env_name):
            new_opsetting_path = os.path.join(os.getcwdu(), EbLocalDir.Path, 
                                           OptionSettingFile.Name + u'.' + new_env_name)
            parameter_pool.put(Parameter(ParameterName.OptionSettingFile,
                                         new_opsetting_path,
                                         parameter_pool.get_source(ParameterName.EnvironmentName)))


    @classmethod
    def ask_solution_stack(cls, parameter_pool):
        # Skip if user supplies solution stack string as CLI arguments, or already by terminal
        if parameter_pool.has(ParameterName.SolutionStack) \
            and ParameterSource.is_ahead(parameter_pool.get_source(ParameterName.SolutionStack),
                                         ParameterSource.ConfigFile):
            print(TerminalPromptSettingParameterMessage[ParameterName.SolutionStack].\
                  format(parameter_pool.get_value(ParameterName.SolutionStack, False)))
            return            
        
        original_value = parameter_pool.get_value(ParameterName.SolutionStack)
        append_message = u'' if original_value is None \
            else TerminalMessage.CurrentValue.format(original_value)        
        print(TerminalPromptAskingMessage[ParameterName.SolutionStack].\
              format(append_message))
        
        stacks = api_wrapper.retrieve_solution_stacks(parameter_pool)
        stack_index = cls.single_choice(stacks, 
                                        TerminalMessage.AvailableSolutionStack, None,
                                        original_value is not None)
        
        value = stacks[stack_index] if stack_index is not None else original_value
        stack = Parameter(ParameterName.SolutionStack, value, ParameterSource.Terminal)
        parameter_pool.put(stack, True)



    @classmethod
    def ask_branch(cls, parameter_pool):
        current_branch = parameter_pool.get_value(ParameterName.CurrentBranch, False)
        prompt.result(TerminalPromptSettingParameterMessage[ParameterName.CurrentBranch]\
                      .format(current_branch))
        
        previous_env_name = parameter_pool.get_value(ParameterName.EnvironmentName)
        cls.ask_branch_environment_name(parameter_pool)
        
        # Ask whether copy from default 
        def_env_name = parameter_pool.get_value(ParameterName.DefaultEnvironmentName, False)
        if previous_env_name is None:
            if cls.ask_confirmation(TerminalMessage.CopyDefaultToBranch.format(def_env_name)):
                return True #Copy from default
        
        # Ask for branch environment settings 
        RdsTerminal.ask_rds_creation(parameter_pool)
        IamTerminal.ask_profile_creation(parameter_pool)
        
        return False # Use user input
    
    
    #--------------------------------
    # Helper methods
    @classmethod
    def generate_env_name(cls, prefix):
        env_name = re.sub(ServiceDefault.Environment.REGEX_NAME_FILTER, 
                           u'', prefix, flags = re.UNICODE)
        if len(env_name) > 0:
            env_name = env_name + ServiceDefault.Environment.NAME_POSTFIX
            if len(env_name) > ServiceDefault.Environment.MAX_NAME_LEN:
                env_name = env_name[:ServiceDefault.Environment.MAX_NAME_LEN]
        else:
            env_name = None    
    
        return env_name
   
