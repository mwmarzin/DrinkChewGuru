require "net/http"
require "uri"
require "httpclient"
require "net/https"



class OpenidController < ApplicationController

	def openIdLogin

	end
	
	def openIdButton
	
	end
	
def getOpenIdXRD
		user = params[:user]
		print user+"\n"
#		xrdurl = "http://www.google.com/s2/webfinger/?q="+user+
#		print xrdurl
		print "Hello...11\n"
		http = HTTPClient.new
		print "Hello...12\n"
		#http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		#response1 = http.get "http://www.google.com/s2/webfinger/?q=teju.chenreddy@gmail.com"
#		response1 = http.get "https://www.google.com/accounts/o8/ud"
		#response1 = http.get "https://accounts.google.com/o/openid2/auth","Content-Type" => "application/xrds+xml"
		response1 = http.get "https://www.google.com/accounts/o8/id","Content-Type" => "application/xrds+xml"
		print "Hello...13\n"
		print response1.content
		@response = response1.content+''
	end
	

end
