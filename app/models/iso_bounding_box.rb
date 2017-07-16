class IsoBoundingBox
  include ActiveModel::Validations

  attr_accessor :lowercorner_longitude
  validates :lowercorner_longitude,
            :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180, :message => '%{value} must be between -180 and 180 degrees'},
            :presence => {:message => 'must be between -180 and 180 degrees'}

  attr_accessor :lowercorner_latitude
  validates :lowercorner_latitude,
            :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90, :message => '%{value} must be between -90 and 90 degrees'},
            :presence => {:message => 'must be between -90 and 90 degrees'}

  attr_accessor :uppercorner_longitude
  validates :uppercorner_longitude,
            :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180, :message => '%{value} must be between -180 and 180 degrees'},
            :presence => {:message => 'must be between -180 and 180 degrees'}

  attr_accessor :uppercorner_latitude
  validates :uppercorner_latitude,
            :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90, :message => '%{value} must be between -90 and 90 degrees'},
            :presence => {:message => 'must be between -90 and 90 degrees'}

  def initialize(bounding_box_envelope_xml)
    @lowercorner_latitude = nil
    @lowercorner_longitude = nil
    @uppercorner_latitude = nil
    @uppercorner_longitude = nil
    lower_corner_node = bounding_box_envelope_xml.at_xpath('//gml:lowerCorner', 'gml' => 'http://www.opengis.net/gml')
    if(lower_corner_node != nil)
      @lowercorner_longitude, @lowercorner_latitude = process_lon_lat(lower_corner_node.text)
    end
    upper_corner_node = bounding_box_envelope_xml.at_xpath('//gml:upperCorner', 'gml' => 'http://www.opengis.net/gml')
    if(upper_corner_node != nil)
      @uppercorner_longitude, @uppercorner_latitude = process_lon_lat(upper_corner_node.text)
    end
  end

  # CMR query is: bounding_box =  lower left longitude, lower left latitude, upper right longitude, upper right latitude
  def to_cmr
    "#{@lowercorner_longitude},#{@lowercorner_latitude},#{@uppercorner_longitude},#{@uppercorner_latitude}"
  end

  private
    def process_lon_lat(lon_lat)
      a = nil
      if(!lon_lat.blank?)
        a = lon_lat.split(/\s+/)
      end
      return a
    end
end