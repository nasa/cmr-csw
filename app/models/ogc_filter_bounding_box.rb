class OgcFilterBoundingBox
  @@ISO_QUERYABLE_NAME = "BoundingBox"
  # AnyText is an ISO queryable
  @@CMR_BOUNDINGBOX_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  # since bounding box requires special processing, we cannot  use the OgcFilterHelper
  # CMR query is: bounding_box =  lower left longitude, lower left latitude, upper right longitude, upper right latitude.
  # gml iso:boundingbox envelope default for WGS84 is:
  # <gml:lowerCorner>LON LAT</gml:lowerCorner>
  # <gml:upperCorner>LON (-180 to + 180) LAT (-90 to +90)</gml:upperCorner>
  # See:
  # http://gis.stackexchange.com/questions/124050/how-do-i-specify-the-lon-lat-ordering-in-csw-bounding-box-request
  # WGS84 / EPSG4326: http://spatialreference.org/ref/epsg/wgs-84/
  # Coordinate Order: http://docs.geotools.org/latest/userguide/library/referencing/order.html
  # TODO support multiple coordinate systems
  # AXIS Order is a MAJOR MAJOR PROBLEM in OpenGis:
  # http://www.ogcnetwork.net/axisorder
  # FOR NOW we require (and document in GetCapas and error messages) the same order as CMR
  def process(ogc_filter)
    cmr_query_hash = {}
    cmr_bounding_box_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["BoundingBox"][1]
    bounding_box = ogc_filter.xpath('//ogc:PropertyName[contains(text(), "BoundingBox")]', 'ogc' => 'http://www.opengis.net/ogc')
    if (bounding_box != nil && bounding_box[0] != nil)
      bounding_box_envelope_node = bounding_box[0].next_element
      if (bounding_box_envelope_node != nil)
        iso_bounding_box = IsoBoundingBox.new(bounding_box_envelope_node)
        if(iso_bounding_box.valid?)
          # the cmr bounding_box only supports a single value and not an array
          cmr_query_hash["#{@@CMR_BOUNDINGBOX_PARAM}"] = iso_bounding_box.to_cmr
        else
          error_message = "not in the supported ISO format. #{iso_bounding_box.errors.full_messages.to_s}"
          Rails.logger.error(error_message)
          raise OwsException.new('BoundingBox', error_message)
        end
      end
    end
    cmr_query_hash
  end
end