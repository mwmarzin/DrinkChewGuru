require 'Location'
class Venue
  attr_accessor :id, :name, :location, :categories, :url, :tips, :likeCount
  
  def to_s
    return "#{name} #{location.to_s}"
  end
end