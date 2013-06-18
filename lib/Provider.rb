class Provider
  attr_accessor :client_id, :client_secret, :redirect_uri, :access_url, :state
  
  def initalize ()
    @state = rand(99999)
  end
end
