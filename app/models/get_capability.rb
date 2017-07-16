class GetCapability < BaseCswModel
  @request_params
  @request
  @request_body

  def initialize(params, request)
    super(params, request)

    if (@request.get?)
      @version = params[:version]
      @service = params[:service]
      @output_file_format = params[:outputFormat].blank? ? 'application/xml' : params[:outputFormat]
    elsif !@request_body.empty? && @request.post?
      request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      @service = request_body_xml.root['service']
      @version = request_body_xml.root['version']
      @output_file_format = request_body_xml.root['outputFormat'].blank? ? 'application/xml' : request_body_xml.root['outputFormat']
    end
  end

  def get_model
    model = OpenStruct.new
    # Add additional items below
    return model
  end
end