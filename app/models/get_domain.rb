class GetDomain < BaseCswModel

  VALID_PROPERTY_NAMES = {'Modified' => 'DomainModified',
                          'TempExtent_begin' => 'DomainTempExtentBegin',
                          'TempExtent_end' => 'DomainTempExtentEnd',
                          'Platform' => 'DomainPlatform',
                          'Instrument' => 'DomainInstrument',
                          'ScienceKeywords' => 'DomainScienceKeywords',
                          'ArchiveCenter' => 'DomainArchiveCenter',
                          'IsCwic' => 'DomainIsCwic',
                          'IsGeoss' => 'DomainIsGeoss',
                          'Provider' => 'DomainProvider'
  }
  # TODO Platform, Instrument, ScienceKeywords once we have a way to get the list of values

  VALID_PARAMETER_NAMES = {'GetRecords.resultType' => 'DomainGetRecordsResultType',
                           'GetRecords.outputFormat' => 'DomainGetRecordsOutputFormat',
                           'GetRecords.outputRecType' => 'DomainGetRecordsOutputRecType',
                           'GetRecords.typeName' => 'DomainGetRecordsTypeName',
                           'GetRecords.ElementSetName' => 'DomainGetRecordsElementSetName',
                           'GetRecords.CONSTRAINTLANGUAGE' => 'DomainGetRecordsConstraintLanguage',
                           'GetRecordById.ElementSetName' => 'DomainGetRecordByIdElementSetName',
                           'DescribeRecord.typeName' => 'DomainDescribeRecordTypeName',
                           'DescribeRecord.schemaLanguage' => 'DomainDescribeRecordSchemaLanguage'
  }

  @request_body_xml

  # NO need for custom validator errors, the spec mentions that the type reference should be returned on error
  attr_accessor :property_names
  #validate :validate_property_names
  attr_accessor :property_names_domain_values

  # NO need for custom validator errors, the spec mentions that the type reference should be returned on error
  attr_accessor :parameter_names
  #validate :validate_parameter_names
  attr_accessor :parameter_names_domain_values

  def initialize (params, request)
    super(params, request)
    # default the output file format
    @output_file_format = 'application/xml'
    @property_names = nil
    @parameter_names = nil
    @property_names_domain_values = Array.new
    @parameter_names_domain_values = Array.new
    if (@request.get?)
      # for GET requests, the spec allows for one or more PropertyName or ParameterName as a comma separated string
      if (!params[:PropertyName].nil?)
        @property_names = params[:PropertyName].gsub(/\s+/, "").split(',')
        if @property_names.empty?
          @property_names = nil
        end
      elsif (!params[:ParameterName].nil?)
        @parameter_names = params[:ParameterName].gsub(/\s+/, "").split(',')
        if @parameter_names.empty?
          @parameter_names = nil
        end
      end
      @version = params[:version]
      @service = params[:service]
    elsif @request.post? && !@request_body.empty?
      # for POST requests XML request body, the spec allows for only ONE PropertyName or ParameterName element
      # TODO might want to support comma separated string for the PropertyName and ParameterName value
      begin
        @request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      rescue Nokogiri::XML::SyntaxError => e
        Rails.logger.error("Could not parse the GetDomain request body XML: #{@request_body} ERROR: #{e.message}")
        raise OwsException.new('NoApplicableCode', "Could not parse the GetDomain request body XML: #{e.message}")
      end
      parameter_name_node = @request_body_xml.root.at_xpath('/csw:GetDomain/csw:ParameterName', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      if (parameter_name_node != nil && !parameter_name_node.text.empty?)
        @parameter_names = [parameter_name_node.text]
      end
      property_name_node = @request_body_xml.root.at_xpath('/csw:GetDomain/csw:PropertyName', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      if (property_name_node != nil && !property_name_node.text.empty?)
        @property_names = [property_name_node.text]
      end
      @service = @request_body_xml.root['service']
      @version = @request_body_xml.root['version']
    end
    if (@property_names == nil && @parameter_names == nil)
      error_message = "ParameterName or PropertyName cannot both be blank. ParameterName allowed values are: #{VALID_PARAMETER_NAMES.keys}. PropertyName allowed values are: #{VALID_PROPERTY_NAMES.keys}"
      Rails.logger.error("Could not process the GetDomain request: #{@request_body} ERROR: #{error_message}")
      raise OwsException.new('PropertyName|ParameterName', "Invalid GetDomain request: #{error_message}")
    end
  end

  def process_domain()
    if !@property_names.nil?
      process_property_names()
    elsif !(@parameter_names.nil?)
      process_parameter_names()
    end
  end

  private
  def process_property_names()
    @property_names.each do |property_name|
      property = Hash.new
      property[:name] = property_name
      if VALID_PROPERTY_NAMES.include?(property_name)
        property_class = VALID_PROPERTY_NAMES[property_name].constantize
        property[:supported] = true
        property[:object] = property_class.new
        property[:class] = property_class
      end
      @property_names_domain_values << property
    end
  end

  def process_parameter_names()
    @parameter_names.each do |parameter_name|
      parameter = Hash.new
      parameter[:name] = parameter_name
      if VALID_PARAMETER_NAMES.include?(parameter_name)
        parameter_class = VALID_PARAMETER_NAMES[parameter_name].constantize
        parameter[:supported] = true
        parameter[:object] = parameter_class.new
        parameter[:class] = parameter_class
      end
      @parameter_names_domain_values << parameter
    end
  end

  # NOT USED for now, unsupported property names result in the unsupported property being returned
  def validate_property_names()
    @property_names.each do |property_name|
      if !VALID_PROPERTY_NAMES.include?(property_name)
        Rails.logger.info("Unsupported GetDomain PropertyName value: #{property_name}")
        #errors.add :property_names, "Value %{value} not supported.  Supported GetDomain PropertyName values are: #{@@VALID_PROPERTY_NAMES}"
      end
    end
  end

  # NOT USED for now, unsupported parameter names result in the unsupported parameter being returned
  def validate_parameter_names()
    @parameter_names.each do |parameter_name|
      if !VALID_PARAMETER_NAMES.include?(property_name)
        #errors.add :parameter_names, "Value %{value} not supported.  Supported GetDomain ParameterName values are: #{@@VALID_PARAMETER_NAMES}"
      end
    end
  end
end