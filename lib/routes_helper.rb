# used by Rails 4 advanced constraint routing lambda (see config/routes.rb)
class RequestRouter

  @@CSW_NAMESPACE = "http://www.opengis.net/cat/csw/2.0.2"

  def self.is_get_record_by_id_get(request)
    return get_helper(request, 'GETRECORDBYID')
  end

  def self.is_get_record_by_id_post(request)
    return post_helper(request, 'GetRecordById')
  end

  def self.is_get_records_post(request)
    return post_helper(request, 'GetRecords')
  end

  def self.is_get_records_get(request)
    return get_helper(request, 'GETRECORDS')
  end

  def self.is_get_capabilities_post(request)
    return post_helper(request, 'GetCapabilities')
  end

  def self.is_get_domain_post(request)
    return post_helper(request, 'GetDomain')
  end

  def self.is_get_capabilities_get(request)
    return get_helper(request, 'GETCAPABILITIES')
  end

  def self.is_get_domain_get(request)
    return get_helper(request, 'GETDOMAIN')
  end

  def self.is_describe_record_get(request)
    return get_helper(request, 'DESCRIBERECORD')
  end

  def self.is_describe_record_post(request)
    return post_helper(request, 'DescribeRecord')
  end

  private

  def self.get_helper(request, request_param_value)
    ret_val = false
    request_value = request.params[:request]
    if request_value != nil
      ret_val = request_value.upcase == request_param_value
    end
    return ret_val
  end

  def self.post_helper(request, csw_post_request_name)
    ret_val = false
    if (request.body != nil)
      request_body_string = request.body.read
      # ensure we don't drain the request body with the above read
      request.body.rewind
      #Rails.logger.info("RequestRouter.post_helper request_body:\n #{request_body_string}")
      # not sure why, sometimes the request_body is an empty string
      if (!request_body_string.blank?)
        xml_request_body = Nokogiri::XML(request_body_string)
        ret_val = (xml_request_body.root.name == csw_post_request_name)
      end
    end
    return ret_val
  end
end
