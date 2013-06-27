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
		response1 = http.get "https://accounts.google.com/o/openid2/auth","Content-Type" => "application/xrds+xml"
		print "Hello...13\n"
		print response1.content
		@response = response1.content+''
	end
	
	def getOpenIdXRD1
		print "Hello...\n"
		uri = URI.parse("https://google/accounts/o8/id")
		print "Hello...1\n"
		# Shortcut
		#response1 = Net::HTTP.get_response(uri)
		
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
#		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		print "Hello...2\n"
#		request = Net::HTTP::Get.new(uri.request_uri)
		response1 = http.request(request)
		print "Hello...3\n"
		
		response1.body
		response1.status
		# Will print response.body
		# Net::HTTP.get_print(uri)	
	end

end
