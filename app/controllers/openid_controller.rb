require "net/http"
require "uri"
require "httpclient"
require "net/https"
require "rexml/document"
include REXML


class OpenidController < ApplicationController

	def openIdLogin

	end
	
	def openIdButton
	
	end
	
	def openIdDetails
		@fname = params[:'openid.ext1.value.firstname']
		@lname = params[:'openid.ext1.value.lastname']
		@email = params[:'openid.ext1.value.email']
		@identity_url = params[:'openid.identity']
		@findUser = User.find_by_email(@email)
		@user
		@message
		if @findUser.nil?
			@user = User.create(first_name: @fname, last_name: @lname, email:@email,identity_url:@identity_url)
			@message = "User Created Successfully"
		else
			@message = "User Already Exists"
		end
	end
	
def getOpenIdXRD
		user = params[:user]
#		print user+"\n"

		http = HTTPClient.new
		response1 = http.get "https://www.google.com/accounts/o8/id","Content-Type" => "application/xrds+xml"
		res = response1.content
		print res
#		xmldoc = Document.new res
#		root = xmldoc.root
#		xrduri = root.elements["XRD/Service/URI"].get_text
		xrduri = extractXRDURI(res)
		print "XRD URI of the document is \n"
		print xrduri
		print "\n"	
		@postResponse = redirect_to(constructURL(xrduri))
		print "\n"
		end
	

	def extractXRDURI(res)
		xmldoc = Document.new res
		root = xmldoc.root
		xrduri = root.elements["XRD/Service/URI"].get_text
	end
	
   def constructURL(xrdurl)
		parameters = "?openid.ns=http://specs.openid.net/auth/2.0
&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select
&openid.identity=http://specs.openid.net/auth/2.0/identifier_select
&openid.return_to=http://drinkchewguru.elasticbeanstalk.com/openid/openIdDetails
&openid.realm=http://drinkchewguru.elasticbeanstalk.com/openid/openIdDetails
&openid.ns.pape=http://specs.openid.net/extensions/pape/1.0
&openid.ns.ui=http://specs.openid.net/extensions/ui/1.0
&openid.ns.ax=http://openid.net/srv/ax/1.0
&openid.ax.mode=fetch_request
&openid.ax.required=email,firstname,lastname
&openid.ax.type.email=http://axschema.org/contact/email
&openid.ax.type.firstname=http://axschema.org/namePerson/first
&openid.ax.type.lastname=http://axschema.org/namePerson/last
&openid.ns.max_auth_age=120
&openid.mode=checkid_setup
&openid.ui.icon=true
&openid.assoc_handle=ABSmpf6DNMw
&openid.ui.mode=popup"
		authURL = xrdurl.to_s()+parameters.to_s()
   end
end
