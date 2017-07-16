class GmlLine
  # the CMR line is specified as a collections of LON LAT (ex. -180 -90) points
  # the gml:LineString is a list of gml:posList whitespace separated coordinates
  include ActiveModel::Validations

  attr_accessor :gml_line
  # custom validators for the point array, individual points are validated by the GmlPoint validation
  validate :validate_array_length
  validate :validate_lon_lat_points

  def initialize(gml_line_xml_node)
    @gml_line = nil
    coordinates_string = gml_line_xml_node.at_xpath('//gml:posList', 'gml' => 'http://www.opengis.net/gml')
    if(coordinates_string != nil && coordinates_string.text != nil)
      # split on whitespace
      @gml_line = coordinates_string.text.split
    end
  end

  # CMR query is: line=lon1,lat1,lon2,lat2,...,lonn,latn
  def to_cmr
    "#{gml_line.join(',')}"
  end

  private
  def validate_array_length
    if !gml_line.is_a?(Array) || gml_line.size == 0 || gml_line.size % 2 != 0
      errors.add :gml_line,  "gml:posList - must be a space separated string of LON LAT point coordinates"
    end
  end

  def validate_lon_lat_points
    # only validate points if there are no errors
    points_hash = Hash.new
    if errors.size == 0
      for i in 0..(gml_line.size / 2 - 1) do
        point = GmlPoint.new(gml_line[i*2], gml_line[i*2 + 1])
        if !point.valid?
          # add individual point errors to parent line errors
          point.errors.each { |k,v| errors.add(k, v) }
        else
          if points_hash.key?(point)
            errors.add :gml_line, "gml:posList - cannot have duplicate points (#{point.longitude} #{point.latitude}"
          else
            points_hash[point] = nil
          end
        end
      end
    end
  end
end