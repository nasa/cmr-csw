class GmlPolygon
  # the CMR Polygon is specified as LON1,LAT1,LON2,LAT2, ... ,LONn,LATn,LON1,LAT1
  # the gml:Polygon is a list of gml:posList whitespace separated coordinates
  include ActiveModel::Validations

  attr_accessor :gml_polygon
  # custom validators for the point array, individual points are validated by the GmlPoint validation
  validate :validate_array_length
  validate :validate_closed_polygon
  validate :validate_lon_lat_points

  def initialize(gml_polygon_xml_node)
    @gml_polygon = nil
    coordinates_string = gml_polygon_xml_node.at_xpath('//gml:posList', 'gml' => 'http://www.opengis.net/gml')
    if (coordinates_string != nil && coordinates_string.text != nil)
      # split on whitespace
      @gml_polygon = coordinates_string.text.split
    end
  end

  # CMR query is: polygon = lon1,lat1,lon2,lat2,...,lonn,latn,lon1,lat1
  def to_cmr
    "#{gml_polygon.join(',')}"
  end

  private
  def validate_array_length
    if gml_polygon == nil || !gml_polygon.is_a?(Array) || gml_polygon.size == 0 || gml_polygon.size % 2 != 0
      errors.add :gml_polygon, "gml:posList - must be a space separated string of LON LAT point coordinates"
    end
  end

  def validate_closed_polygon
    if errors.size == 0
      first_lon = gml_polygon[0]
      first_lat = gml_polygon[1]
      total_coords = gml_polygon.size
      last_lon = gml_polygon[total_coords - 2]
      last_lat = gml_polygon[total_coords - 1]
      if first_lon != last_lon || first_lat != last_lat
        errors.add :gml_polygon, "gml:posList - first (#{first_lon} #{first_lat}) and last (#{last_lon} #{last_lat}) point of the polygon must be indentical"
      end
    end
  end

  def validate_lon_lat_points
    # only validate points if there are no errors
    if errors.size == 0
      for i in 0..(gml_polygon.size / 2 - 1) do
        point = GmlPoint.new(gml_polygon[i*2], gml_polygon[i*2 + 1])
        if !point.valid?
          point.errors.each { |k, v| errors.add(k, v) }
        end
      end
    end
  end
end