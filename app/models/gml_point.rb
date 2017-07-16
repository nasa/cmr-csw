class GmlPoint
  # the CMR point is specified as LON LAT (ex. -180 -90)
  # the gml:Point is gml:pos TWO whitespace separated coordinates
  # See: http://www.georss.org/gml.html#gmlpoint
  include ActiveModel::Validations

  attr_accessor :longitude
  validates :longitude,
            :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180, :message => "%{value} must be between -180 and 180 degrees"},
            :presence => {:message => 'must be provided'}

  attr_accessor :latitude
  validates :latitude,
            :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90, :message => "%{value} must be between -90 and 90 degrees"},
            :presence => {:message => 'must be provided'}

  # use point for Polygon, LineString and Point
  def initialize(point_longitude, point_latitude, gml_point_xml_node = nil)
    if gml_point_xml_node.nil?
      @longitude = point_longitude
      @latitude = point_latitude
    else
      coordinates_string = gml_point_xml_node.at_xpath('//gml:pos', 'gml' => 'http://www.opengis.net/gml')
      if(coordinates_string != nil && coordinates_string.text != nil)
        # split on whitespace
        coordinates_array = coordinates_string.text.split
        if(coordinates_array.size == 2)
          @longitude = coordinates_array[0]
          @latitude = coordinates_array[1]
        else
          errors.add :gml_point,  "gml:pos - must be a space separated string of one LON LAT point coordinates"
        end
      end
    end
  end

  def ==(other)
    self.class === other and
        other.longitude == @longitude and
        other.latitude == @latitude
  end

  alias eql? ==

  def hash
    @longitude.hash ^ @latitude.hash # XOR
  end

  def to_s
    return "(lon #{@latitude} lat #{@longitude}"
  end

  def to_cmr
    return "#{@longitude},#{@latitude}"
  end
end