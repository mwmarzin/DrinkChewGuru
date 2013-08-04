module Exceptions
  class OauthError < StandardError; end
  class InvalidTokenError < OauthError; end 
  class PermissionRevokedError < OauthError; end
end