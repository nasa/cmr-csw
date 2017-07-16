require 'spec_helper'

#constraint = 'AnyText=12345 and BoundingBox=-180,-90,+180,90'
# AnyText=1234 and BoundingBox=-180,-90,+180.000,+90.0 and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z

RSpec.describe CqlFilter do
  describe 'Various CQL Filtering scenarios' do

    it 'is possible to process the AnyText queryable' do
      constraint = 'AnyText=12345'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['keyword']).to eq('12345')
    end

    it 'is possible to process the ArchiveCenter queryable' do
      constraint = 'ArchiveCenter=DHL'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['archive_center']).to eq('DHL')
    end

    it 'is possible to process the IsCwic queryable' do
      constraint = 'IsCwic=true'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['tag_key']).to eq(Rails.configuration.cwic_tag)
    end

    it 'is possible to process the IsGeoss queryable' do
      constraint = 'IsGeoss=true'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['tag_key']).to eq(Rails.configuration.geoss_data_core_tag)
    end

    it 'is possible to process the AnyText queryable with wildcard support' do
      constraint = 'AnyText=12?345*'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['keyword']).to eq('12?345*')
      expect(cmr_query_hash['options[keyword][pattern]']).to be true
    end

    it 'is possible to process the ArchiveCenter queryable with wildcard support' do
      constraint = 'ArchiveCenter=12?345*'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['archive_center']).to eq('12?345*')
      expect(cmr_query_hash['options[archive_center][pattern]']).to be true
    end


    it 'is NOT possible to process an invalid CQL queryable' do
      constraint = 'InvalidQueryable=12?345*'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      begin
        cql_filter.process_constraint
      rescue OwsException => e
        expect(e.text).to include("The value for 'constraint' query parameter is not supported")
      end
    end

    it 'is possible to process the BoundingBox queryable' do
      # CMR does not allow + for the lat, lon and it only allows -
      constraint = 'BoundingBox=-180,-90,180.000,90.0'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['bounding_box']).to eq('-180,-90,180.000,90.0')
    end

    it 'is possible to process the TempExtent_begin queryable' do
      # CMR does not allow + for the lat, lon and it only allows -
      constraint = 'TempExtent_begin=1990-09-03T00:00:01Z'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['temporal']).to eq('1990-09-03T00:00:01Z/')
    end

    it 'is possible to process the TempExtent_end queryable' do
      # CMR does not allow + for the lat, lon and it only allows -
      constraint = 'TempExtent_end=2008-09-06T23:59:59Z'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['temporal']).to eq('/2008-09-06T23:59:59Z')
    end

    it 'is possible to process the TempExtent_begin and TempExtent_end queryables' do
      # CMR does not allow + for the lat, lon and it only allows -
      constraint = 'TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['temporal']).to eq('1990-09-03T00:00:01Z/2008-09-06T23:59:59Z')
    end

    it 'is possible to process the AnyText, BoundingBox, TempExtent_begin and TempExtent_end queryables' do
      # CMR does not allow + for the lat, lon and it only allows -
      constraint = 'AnyText=12?345* and BoundingBox=-180,-90,180.000,90.0 and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      cql_filter.process_constraint
      expect(cmr_query_hash.size).to_not equal(0)
      expect(cmr_query_hash['keyword']).to eq('12?345*')
      expect(cmr_query_hash['options[keyword][pattern]']).to be true
      expect(cmr_query_hash['bounding_box']).to eq('-180,-90,180.000,90.0')
      expect(cmr_query_hash['temporal']).to eq('1990-09-03T00:00:01Z/2008-09-06T23:59:59Z')

    end

    it 'is NOT possible to process an invalid date in a temporal query' do
      constraint = 'TempExtent_begin=1990-09-03M00:00:01Z'
      constraint_language = 'CQL_TEXT'
      cmr_query_hash = Hash.new
      cql_filter = CqlFilter.new(constraint, constraint_language, cmr_query_hash)
      begin
        cql_filter.process_constraint
      rescue OwsException => e
        expect(e.text).to include("'1990-09-03M00:00:01Z' is NOT in the supported ISO8601 format yyyy-MM-ddTHH:mm:ssZ")
      end
    end

  end
end