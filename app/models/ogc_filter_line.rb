class OgcFilterLine
    @@CMR_QUERY_PARAM = "line"

    # CMR query is: lon1, lat1, lon2, lat2, lon3, lat3, ... lonn, latn
    # CMR needs more docs for the 2D coordinate system name so that the coordianate order can be properly inferred from the CRS
    # Coordinate system / Axis Order is an absolute MESS in GIS.  The proper / unambiguous way to deal with it is to clearly
    # document the behavior / expectations in the code:
    # http://www.ogcnetwork.net/axisorder
    # http://docs.geotools.org/latest/userguide/library/referencing/order.html
    # FOR NOW we require (and document in GetCapas and error messages) the same order as CMR
    # See http://www.georss.org/gml.html#gmline
    def process(ogc_filter)
      cmr_query_hash = {}
      gml_linestring_node_set = ogc_filter.xpath('//gml:LineString', 'gml' => 'http://www.opengis.net/gml')
      if (gml_linestring_node_set != nil && gml_linestring_node_set[0] != nil)
        gml_line = GmlLine.new(gml_linestring_node_set[0])
        if (gml_line.valid?)
          # the cmr line only supports a single value and not an array
          cmr_query_hash["#{@@CMR_QUERY_PARAM}"] = gml_line.to_cmr
        else
          error_message = "not in the supported GML format. #{gml_line.errors.full_messages.to_s}"
          Rails.logger.error(error_message)
          raise OwsException.new('LineString', error_message)
        end
      end
      cmr_query_hash
    end
end