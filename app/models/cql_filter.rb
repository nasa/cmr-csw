# Accorging to the CSW specification, the only way to execute a GET without XML ecoding is via the CQL language and the
# constraint query parameter.  The XML encoding results in more complex queries and can run into URL length limitations.
#
class CqlFilter
  CONSTRAINT_LAGUAGES = %w(CQL_TEXT)
  SUPPORTED_CQL_QUERYABLES = %w(AnyText ArchiveCenter BoundingBox TempExtent_begin TempExtent_end IsCwic IsGeoss Provider)

  @constraint
  @constraint_language
  @cmr_query_hash

  def initialize (constraint, constraint_language, cmr_query_hash)
    @constraint = constraint
    @constraint_language = constraint_language

    if (!@constraint.empty? && !CONSTRAINT_LAGUAGES.include?(@constraint_language))
      error_message = "GetRecords GET request error: "
      if @constraint_language.empty?
        error_message = error_message + "the CONSTRAINTLANGUAGE query parameter cannot be blank and must equal 'CQL_TEXT' when the [constraint=#{@constraint}] is specified."
      else
        error_message = error_message + "the CONSTRAINTLANGUAGE query parameter value '#{@constraint_language}' is not supported. The only supported value is CQL."
      end
      Rails.logger.error(error_message)
      raise OwsException.new('query_language', error_message)
    end
    @cmr_query_hash = cmr_query_hash
  end

  def process_constraint
    cql_parser = CqlParser.new
    begin
      parser_results = cql_parser.parse(@constraint)
      process_parser_results(parser_results)
    rescue Parslet::ParseFailed => error
      parser_error = error.cause.ascii_tree
      error_message = "The value for 'constraint' query parameter is not supported and cannot be parsed: #{parser_error}"
      Rails.logger.error(error_message)
      raise OwsException.new('constraint', error_message)
    end
  end

  private
  def process_parser_results(parser_results)
    begin_date = nil
    end_date = nil
    parser_results.each  do |parser_result_hash|
        queryable = parser_result_hash[:key].str
        queryable_value = parser_result_hash[:value].str
      case queryable
        when 'AnyText'
          @cmr_query_hash.reverse_merge!(CqlFilterAnyText.process(queryable_value))
        when 'ArchiveCenter'
          @cmr_query_hash.reverse_merge!(CqlFilterArchiveCenter.process(queryable_value))
        when 'Provider'
          @cmr_query_hash.reverse_merge!(CqlFilterProvider.process(queryable_value))
        when 'BoundingBox'
          @cmr_query_hash.reverse_merge!(CqlFilterBoundingBox.process(queryable_value))
        when 'TempExtent_begin'
          begin_date = queryable_value
        when 'TempExtent_end'
          end_date = queryable_value
        when 'IsCwic'
          @cmr_query_hash.reverse_merge!(CqlFilterIsCwic.process(queryable_value))
        when 'IsGeoss'
          @cmr_query_hash.reverse_merge!(CqlFilterIsGeoss.process(queryable_value))
        else
          error_message = "The queryable #{queryable} is not supported by the CMR CSW implementation"
          Rails.logger.error(error_message)
          raise OwsException.new('constraint', error_message)
      end
    end
    if !begin_date.nil? || !end_date.nil?
      @cmr_query_hash.reverse_merge!(CqlFilterTemporal.process(begin_date, end_date))
    end
  end
end