class OgcFilterPolygon
  @@CMR_QUERY_PARAM = "polygon"

  # CMR query is: lon1, lat1, lon2, lat2, lon3, lat3, lon1, lat1 (to close the polygon)
  # CMR needs more docs for the 2D coordinate system name so that the coordianate order can be properly inferred from the CRS
  # ?polygon=10,10,30,10,30,20,10,20,10,10
  # Coordinate system / Axis Order is an absolute MESS in GIS.  The proper / unambiguous way to deal with it is to clearly
  # document the behavior / expectations in the code:
  # http://www.ogcnetwork.net/axisorder
  # http://docs.geotools.org/latest/userguide/library/referencing/order.html
  # FOR NOW we require (and document in GetCapas and error messages) the same order as CMR
  # See: http://www.georss.org/gml.html#gmlboundary
  def process(ogc_filter)
    cmr_query_hash = {}
    gml_polygon_node_set = ogc_filter.xpath('//gml:Polygon', 'gml' => 'http://www.opengis.net/gml')
    if (gml_polygon_node_set != nil && gml_polygon_node_set[0] != nil)
      gml_polygon = GmlPolygon.new(gml_polygon_node_set[0])
      if (gml_polygon.valid?)
        # the cmr polygon only supports a single value and not an array
        cmr_query_hash["#{@@CMR_QUERY_PARAM}"] = gml_polygon.to_cmr
      else
        error_message = "not in the supported GML format. #{gml_polygon.errors.full_messages.to_s}"
        Rails.logger.error(error_message)
        raise OwsException.new('Polygon', error_message)
      end
    end
    cmr_query_hash
  end
end