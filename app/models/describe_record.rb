class DescribeRecord < BaseCswModel

  attr_accessor :output_schema
  validates :output_schema, inclusion: {in: OUTPUT_SCHEMAS, message: "Output schema '%{value}' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi, http://www.isotc211.org/2005/gmd"}

  # Array of TypeNames in the request
  attr_accessor :type_names
  validate :validate_type_names

  attr_accessor :schema_language
  validates :schema_language, inclusion: {in: %w{http://www.w3.org/2001/XMLSchema XMLSCHEMA}, message: "Schema Language '%{value}' is not supported. Supported output file format is http://www.w3.org/2001/XMLSchema, XMLSCHEMA"}

  # Hash of namespaces in the request {key = TypeName prefix, value = Namespace}
  attr_accessor :namespaces
  validate :validate_namespaces

  validate :validate_method

  def initialize (params, request)
    super(params, request)

    if (@request.get?)
      @output_schema = params[:outputSchema].blank? ? 'http://www.isotc211.org/2005/gmi' : params[:outputSchema]

      @output_file_format = params[:outputFormat].blank? ? 'application/xml' : params[:outputFormat]

      @schema_language = params[:schemaLanguage].blank? ? 'XMLSCHEMA' : params[:schemaLanguage]

      @namespaces = to_output_schemas(params[:NAMESPACE])

      @type_names = params[:TypeName].blank? ? [] : params[:TypeName].split(',')

      @version = params[:version]

      @service = params[:service]
    elsif !@request_body.empty? && @request.post?
      begin
        @request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      rescue Nokogiri::XML::SyntaxError => e
        Rails.logger.error("Could not parse the DescribeRecord request body XML: #{@request_body} ERROR: #{e.message}")
        raise OwsException.new('NoApplicableCode', "Could not parse the GetRecords request body XML: #{e.message}")
      end
      output_schema_value = @request_body_xml.root['outputSchema']
      @output_schema = output_schema_value.blank? ? 'http://www.isotc211.org/2005/gmi' : output_schema_value
      schema_language_value = @request_body_xml.root['schemaLanguage']
      @schema_language = schema_language_value.blank? ? 'XMLSCHEMA' : schema_language_value
      output_file_format_value = @request_body_xml.root['outputFormat']
      @output_file_format = output_file_format_value.blank? ? 'application/xml' : output_file_format_value
      @service = @request_body_xml.root['service']
      @version = @request_body_xml.root['version']
      process_post_typenames_and_namespaces()
    end
  end

  def get_model
    model = OpenStruct.new
    model.schemas = []
    @namespaces.each_pair do |key, value|
      schema = OpenStruct.new
      schema.namespace = value
      # Switch on namespace
      file = nil
      case value
        when 'http://www.opengis.net/cat/csw/2.0.2'
          file = File.open('app/models/schemas/csw_record.xsd', 'rb')
        when 'http://www.isotc211.org/2005/gmi'
          file = File.open('app/models/schemas/gmi_record.xsd', 'rb')
        when 'http://www.isotc211.org/2005/gmd'
          file = File.open('app/models/schemas/gmd_record.xsd', 'rb')
      end
      unless file.nil?
        schema.content = file.read
        model.schemas << schema
      end
    end
    model
  end

  private

  def validate_method
    if (!@request.post? && !@request.get?)
      errors.add(:method, 'Only the HTTP POST and GET methods are supported for DescribeRecord')
    end
  end

  def validate_namespaces
    @namespaces.each_pair do |key, value|
      errors.add(:namespaces, "Namespace '#{value}' is not supported. Supported namespaces are #{OUTPUT_SCHEMAS.join(', ')}") unless OUTPUT_SCHEMAS.include? value
    end
  end

  def validate_type_names
    # We only support the root type names and the prefix must also match one of the namespaces given in the request
    @type_names.each do |type_name|
      # Get the prefix
      prefix = nil
      if type_name.include? ':'
        prefix = type_name.split(':')[0]
        element = type_name.split(':')[1]
      else
        element = type_name
      end
      # Is the prefix one of the ones in the namespaces?
      unless @namespaces.has_key? prefix.to_sym
        errors.add(:type_names, "Prefix '#{prefix}' does not map to any of the supplied namespaces")
      else
        href = @namespaces[prefix.to_sym]
        # Is the type one we can service?
        case element
          when 'Record'
            errors.add(:type_names, "'Record' is not part of the #{href} schema") unless href == 'http://www.opengis.net/cat/csw/2.0.2'
          when 'MI_Metadata'
            errors.add(:type_names, "'MI_Metadata' is not part of the #{href} schema") unless href == 'http://www.isotc211.org/2005/gmi'
          when 'MD_Metadata'
            errors.add(:type_names, "'MD_Metadata' is not part of the #{href} schema") unless href == 'http://www.isotc211.org/2005/gmd'
          else
            errors.add(:type_names, "'#{element}' is not a supported element for description. Supported elements are 'csw:Record', 'gmi:MI_Metadata' and 'gmd:MD_Metadata'")
        end
      end
    end
  end

  # special processing for POST request
  def process_post_typenames_and_namespaces()
    type_names_node_set = @request_body_xml.xpath('//csw:DescribeRecord//csw:TypeName',
                                                  'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
    if (type_names_node_set != nil && type_names_node_set.size > 0)
      @type_names = []
      @namespaces = {}
      namespace_definitions = @request_body_xml.root.namespaces
      type_names_node_set.each do |type_name|
        # must work around to present indetical hashes for model validation for both GET and POST
        node_namespace_prefix_orig = type_name.text.split(':')[0]
        if (node_namespace_prefix_orig == type_name.text)
          # no namespace
          node_namespace_prefix = 'xmlns'
          node_namespace_prefix_orig = 'default'
        else
          node_namespace_prefix = "xmlns:#{node_namespace_prefix_orig}"
        end
        node_namespace_href = namespace_definitions[node_namespace_prefix]
        if !node_namespace_href.nil?
          @namespaces[node_namespace_prefix_orig.to_sym] = node_namespace_href
        end
        @type_names << type_name.text
      end
    else
      @type_names = []
    end
    if (@namespaces.nil? || @namespaces.empty?)
      @namespaces = {:gmi => 'http://www.isotc211.org/2005/gmi'}
    end
  end

  # xmlns(gml=http://www.opengis.org/gml),xmlns(wfs=http:// www.opengis.org/wfs), xmlns(http://www.opengis.net/cat/csw/2.0.2)
  # turn in into {:gml => "http://www.opengis.org/gml", :wfs => "http:// www.opengis.org/wfs",
  #               :default => "http://www.opengis.net/cat/csw/2.0.2" }
  def to_output_schemas(namespaces)
    schemas = {}
    unless namespaces.blank?
      namespaces.gsub!('),xmlns(', ',')
      namespaces.gsub!('xmlns(', '')
      namespaces.chop!
      ns = namespaces.split(',')

      ns.each do |n|
        if n.include? '='
          prefix = n.split('=')[0]
          href = n.split('=')[1]
          schemas[prefix.to_sym] = href
        else
          prefix = 'default'
          href = n
          schemas[prefix.to_sym] = href
        end
      end
    else
      schemas[:gmi] = 'http://www.isotc211.org/2005/gmi'
    end
    schemas
  end

end
