class OgcFilterPoint
  @@CMR_QUERY_PARAM = "point"

  # CMR query is: point=lon,lat
  # CMR needs more docs for the 2D coordinate system name so that the coordianate order can be properly inferred from the CRS
  # Coordinate system / Axis Order is an absolute MESS in GIS.  The proper / unambiguous way to deal with it is to clearly
  # document the behavior / expectations in the code:
  # http://www.ogcnetwork.net/axisorder
  # http://docs.geotools.org/latest/userguide/library/referencing/order.html
  # FOR NOW we require (and document in GetCapas and error messages) the same order as CMR
  # See http://www.georss.org/gml.html#gmlpoint
  def process(ogc_filter)
    cmr_query_hash = {}
    gml_point_node_set = ogc_filter.xpath('//gml:Point', 'gml' => 'http://www.opengis.net/gml')
    if (gml_point_node_set != nil && gml_point_node_set[0] != nil)
      # alternate ctor workaround
      gml_point = GmlPoint.new(nil, nil, gml_point_node_set[0])
      if (gml_point.valid?)
        # the cmr line only supports a single value and not an array
        cmr_query_hash["#{@@CMR_QUERY_PARAM}"] = gml_point.to_cmr
      else
        error_message = "not in the supported GML format. #{gml_point.errors.full_messages.to_s}"
        Rails.logger.error(error_message)
        raise OwsException.new('Point', error_message)
      end
    end
    cmr_query_hash
  end
end
