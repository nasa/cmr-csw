class GetRecordById < BaseCswModel

  RESPONSE_ELEMENTS = %w(brief summary full)

  attr_accessor :id
  validates :id, presence: {message: 'id can\'t be blank'}

  attr_accessor :response_element
  validates :response_element, inclusion: {in: RESPONSE_ELEMENTS, message: "Element set name '%{value}' is not supported. Supported element set names are brief, summary, full"}

  attr_accessor :output_schema
  validates :output_schema, inclusion: {in: OUTPUT_SCHEMAS, message: "Output schema '%{value}' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi"}

  def initialize (params, request)
    super(params, request)

    if (@request.get?)
      @output_schema = params[:outputSchema].blank? ? 'http://www.isotc211.org/2005/gmi' : params[:outputSchema]
      @output_file_format = params[:outputFormat].blank? ? 'application/xml' : params[:outputFormat]
      @response_element = params[:ElementSetName].blank? ? 'summary' : params[:ElementSetName]
      @id = params[:id]
      @version = params[:version]
      @service = params[:service]
    elsif !@request_body.empty? && @request.post?
      request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      @output_schema = request_body_xml.root['outputSchema'].blank? ? 'http://www.isotc211.org/2005/gmi' : request_body_xml.root['outputSchema']
      @output_file_format = request_body_xml.root['outputFormat'].blank? ? 'application/xml' : request_body_xml.root['outputFormat']
      @response_element = request_body_xml.root.xpath('/csw:GetRecordById/csw:ElementSetName', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text.blank? ? 'summary' : request_body_xml.root.xpath('/csw:GetRecordById/csw:ElementSetName', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text
      @id = ''
      request_body_xml.root.xpath('/csw:GetRecordById/csw:Id', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').each do |id|
        @id << id.text << ','
      end
      @id.chomp! ','

      @service = request_body_xml.root['service']
      @version = request_body_xml.root['version']
    end
  end

  def find
    cmr_params = to_cmr_collection_params
    Rails.logger.info "CMR Params: #{cmr_params}"
    response = nil
    begin
      time = Benchmark.realtime do
        query_url = "#{Rails.configuration.cmr_search_endpoint}/collections"
        Rails.logger.info "RestClient call to CMR endpoint: #{query_url}?#{cmr_params.to_query}"
        # RestClient does not support array parameters in a query so we have to inline them in the url parameter. Which sucks...
        response = RestClient::Request.execute :method => :get, :url => "#{query_url}?#{cmr_params.to_query}", :verify_ssl => OpenSSL::SSL::VERIFY_NONE, :headers => {:client_id => ENV['client_id'], :accept => 'application/iso19115+xml'}
      end
      Rails.logger.info "CMR collection search took #{(time.to_f * 1000).round(0)} ms"
    rescue RestClient::BadRequest => e
      # An unknown concept id will give a bad request error
      response = e.response if e.response.include?('Concept-id') && e.response.include?('is not valid')
    end
    document = Nokogiri::XML(response)
    document = BaseCswModel.add_cwic_keywords document
    # This model is an array of collections in the iso19115 format. It's up to the view to figure out how to render it
    # Each gmi:MI_Metadata element is a collection
    model = OpenStruct.new
    model.output_schema = @output_schema
    model.response_element = @response_element
    model.raw_collections_doc = document
    if document.at_xpath('/results/hits').nil?
      model.number_of_records_matched = 0
    else
      model.number_of_records_matched = document.at_xpath('/results/hits').text.to_i
    end
    model
  end

  private

  def to_cmr_collection_params
    cmr_params = {}
    id_array = []
    # The Id parameter is a comma-separated list of concept ids. This needs to converted into a repeated number of concept_id parameters
    # For example,
    # Id=C1224520098-NOAA_NCEI,C1224520058-NOAA_NCEI
    # becomes
    # concept_id[]=C1224520098-NOAA_NCEI&concept_id[]=C1224520058-NOAA_NCEI
    unless @id.blank?
      @id.split(',').each do |id|
        id_array.append id
      end
    end
    cmr_params[:concept_id] = id_array
    # for GetRecordById the false flag indicated that we don't want special filtering for CWICSmart invocation since the
    # GerRecordById invocation from CWIC already has a concept-id to identify the record of interest and it will already
    # be a CWIC record since its parent dataset retrieved via GetRecords is already a CWIC dataset
    cmr_params = add_cwic_parameter(cmr_params,false)
    cmr_params
  end
end
