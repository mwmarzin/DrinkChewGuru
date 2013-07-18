class Location
  attr_accessor :address, :zip, :city, :state, :country  
  
  def to_s
    return "#{address}, #{city} #{state}, #{zip}"
  end
end