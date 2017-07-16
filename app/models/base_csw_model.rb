class BaseCswModel
  #TODO refactor ALL common CSW models behavior here
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  OUTPUT_FILE_FORMATS = %w(application/xml)
  IS_CWIC = %w(true)
  IS_GEOSS = %w(true)
  HTTP_METHODS = %w{Get Post}
  OUTPUT_SCHEMAS = %w(http://www.opengis.net/cat/csw/2.0.2 http://www.isotc211.org/2005/gmi http://www.isotc211.org/2005/gmd)
  TYPE_NAMES = %w(csw:Record gmi:MI_Metadata gmd:MD_Metadata)

  @request_params
  @request
  @request_body

  attr_accessor :output_file_format
  validates :output_file_format, inclusion: {in: OUTPUT_FILE_FORMATS, message: "Output file format '%{value}' is not supported. Supported output file format is application/xml"}

  attr_accessor :version
  validate :validate_version

  attr_accessor :service
  validate :validate_service

  def initialize(params, request)
    @request_params = params
    @request = request
    @request_body = request.body.read
  end

  def add_cwic_parameter(params, invoked_from_cwicsmart)
    params[:include_tags] = "#{Rails.configuration.cwic_tag},#{Rails.configuration.geoss_data_core_tag}"
    if(invoked_from_cwicsmart)
      params[:tag_key] = Rails.configuration.cwic_tag
    end
    params
  end

  def self.add_cwic_keywords(document)
    # For each result with a CWIC tag. If it exists insert a gmd:keyword as follows,
    document.xpath('/results/result/tags/tag/tagKey').each do |tag|
      if tag.content.strip == Rails.configuration.cwic_tag or tag.content.strip == Rails.configuration.geoss_data_core_tag
        result = tag.parent().parent().parent()
        keywords = result.xpath('gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords',
                                'gmd' => 'http://www.isotc211.org/2005/gmd', 'gmi' => 'http://www.isotc211.org/2005/gmi')
        keyword_1 = Nokogiri::XML::Node.new 'gmd:keyword', document
        keyword_2 = Nokogiri::XML::Node.new 'gmd:keyword', document
        text_1 = Nokogiri::XML::Node.new 'gco:CharacterString', document
        text_2 = Nokogiri::XML::Node.new 'gco:CharacterString', document
        text_2.content = Rails.configuration.geoss_data_core_descriptive_keyword_2
        if tag.content.strip == Rails.configuration.cwic_tag
          text_1.content = Rails.configuration.cwic_descriptive_keyword
        else
          text_1.content = Rails.configuration.geoss_data_core_descriptive_keyword_1
        end

        keyword_1.add_child text_1
        keyword_2.add_child text_2 if tag.content.strip == Rails.configuration.geoss_data_core_tag
        if keywords.empty?
          # Add a descriptive keywords node at gmd:MD_DataIdentification
          di = result.xpath('gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification', 'gmd' => 'http://www.isotc211.org/2005/gmd',
                            'gmi' => 'http://www.isotc211.org/2005/gmi')
          dks = Nokogiri::XML::Node.new 'gmd:descriptiveKeywords', document
          keywords = Nokogiri::XML::Node.new 'gmd:MD_Keywords', document
          di.first.prepend_child dks
          dks.add_child keywords
          keywords.add_child keyword_1
          keywords.add_child keyword_2 if tag.content.strip == Rails.configuration.geoss_data_core_tag
        else
          keywords.first.prepend_child keyword_1
          keywords.first.prepend_child keyword_2 if tag.content.strip == Rails.configuration.geoss_data_core_tag
        end
      end
    end
    document
  end

  private

  # We have a combination of required and controlled values for both version and service
  def validate_version
    if @version.blank?
      errors.add(:version, "version can't be blank")
    elsif @version != '2.0.2'
      errors.add(:version, "version '#{@version}' is not supported. Supported version is '2.0.2'")
    end
  end

  # We have a combination of required and controlled values for both version and service
  def validate_service
    if @service.blank?
      errors.add(:service, "service can't be blank")
    elsif @service != 'CSW'
      errors.add(:service, "service '#{@service}' is not supported. Supported service is 'CSW'")
    end
  end

end