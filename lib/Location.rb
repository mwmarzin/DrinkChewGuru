class Location
  attr_accessor :address, :zip, :city, :state, :country  
  
  def to_s
    return_string = ""
    if address.nil? || address.blank?
      return " #{city} #{state}, #{zip}"
    else
      return "#{address}, #{city} #{state}, #{zip}"
    end
  end
end