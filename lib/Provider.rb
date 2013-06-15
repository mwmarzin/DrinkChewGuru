class Provider
  class << self
    attr_reader :client_id, :client_secret, :redirect_uri, :access_url, :state
  end
  def initalize ()
    @state = rand(99999)
  end
end
