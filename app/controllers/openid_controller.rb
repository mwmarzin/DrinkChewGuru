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
	
def getOpenIdXRD
		user = params[:user]
		print user+"\n"

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
&openid.return_to=http://drinkchewguru.elasticbeanstalk.com/oauth
&openid.realm=http://drinkchewguru.elasticbeanstalk.com/oauth
&openid.assoc_handle=ABSmpf6DNMw
&openid.mode=checkid_setup
&openid.ui.mode=popup"
		authURL = xrdurl.to_s()+parameters.to_s()
   end

	

end
