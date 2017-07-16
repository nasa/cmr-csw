require 'spec_helper'
require 'parslet/rig/rspec'

RSpec.describe CqlParser do
  describe 'Various CQL Parsing scenarios' do

    it 'is possible to parse IsCwic' do
      begin
        CqlParser.new.cqlconstraint_iscwic.parse('IsCwic')
        expect(CqlParser.new.cqlconstraint_iscwic).to parse('IsCwic')
        expect(CqlParser.new.cqlconstraint_iscwic).to parse('IsCwic ')
        expect(CqlParser.new.cqlconstraint_iscwic).to parse('IsCwic   ')
        expect(CqlParser.new.cqlconstraint_iscwic).to parse(' IsCwic')
        expect(CqlParser.new.cqlconstraint_iscwic).to parse('  IsCwic ')
        expect(CqlParser.new.cqlconstraint_iscwic).to parse('   IsCwic   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse IsGeoss' do
      begin
        CqlParser.new.cqlconstraint_isgeoss.parse('IsGeoss')
        expect(CqlParser.new.cqlconstraint_isgeoss).to parse('IsGeoss')
        expect(CqlParser.new.cqlconstraint_isgeoss).to parse('IsGeoss ')
        expect(CqlParser.new.cqlconstraint_isgeoss).to parse('IsGeoss   ')
        expect(CqlParser.new.cqlconstraint_isgeoss).to parse(' IsGeoss')
        expect(CqlParser.new.cqlconstraint_isgeoss).to parse('  IsGeoss ')
        expect(CqlParser.new.cqlconstraint_isgeoss).to parse('   IsGeoss   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse a BoundingBox' do
      begin
        # bbox
        CqlParser.new.cqlconstraint_bbox.parse('BoundingBox')
        expect(CqlParser.new.cqlconstraint_bbox).to parse('BoundingBox')
        expect(CqlParser.new.cqlconstraint_bbox).to parse('BoundingBox ')
        expect(CqlParser.new.cqlconstraint_bbox).to parse('BoundingBox   ')
        expect(CqlParser.new.cqlconstraint_bbox).to parse(' BoundingBox')
        expect(CqlParser.new.cqlconstraint_bbox).to parse('  BoundingBox ')
        expect(CqlParser.new.cqlconstraint_bbox).to parse('   BoundingBox   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse an AnyText' do
      begin
        # AnyText
        CqlParser.new.cqlconstraint_anytext.parse('AnyText')
        expect(CqlParser.new.cqlconstraint_anytext).to parse('AnyText')
        expect(CqlParser.new.cqlconstraint_anytext).to parse('AnyText ')
        expect(CqlParser.new.cqlconstraint_anytext).to parse('AnyText   ')
        expect(CqlParser.new.cqlconstraint_anytext).to parse(' AnyText')
        expect(CqlParser.new.cqlconstraint_anytext).to parse('  AnyText ')
        expect(CqlParser.new.cqlconstraint_anytext).to parse('   AnyText   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse a TempExtent_begin' do
      begin
        # TimeExtent_begin
        CqlParser.new.cqlconstraint_tbegin.parse('TempExtent_begin')
        expect(CqlParser.new.cqlconstraint_tbegin).to parse('TempExtent_begin')
        expect(CqlParser.new.cqlconstraint_tbegin).to parse('TempExtent_begin ')
        expect(CqlParser.new.cqlconstraint_tbegin).to parse('TempExtent_begin   ')
        expect(CqlParser.new.cqlconstraint_tbegin).to parse(' TempExtent_begin')
        expect(CqlParser.new.cqlconstraint_tbegin).to parse('  TempExtent_begin ')
        expect(CqlParser.new.cqlconstraint_tbegin).to parse('   TempExtent_begin   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse a TempExtent_end' do
      begin
        # TimeExtent_end
        CqlParser.new.cqlconstraint_tend.parse('TempExtent_end')
        expect(CqlParser.new.cqlconstraint_tend).to parse('TempExtent_end')
        expect(CqlParser.new.cqlconstraint_tend).to parse('TempExtent_end ')
        expect(CqlParser.new.cqlconstraint_tend).to parse('TempExtent_end   ')
        expect(CqlParser.new.cqlconstraint_tend).to parse(' TempExtent_end')
        expect(CqlParser.new.cqlconstraint_tend).to parse('  TempExtent_end ')
        expect(CqlParser.new.cqlconstraint_tend).to parse('   TempExtent_end   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the equals operator' do
      begin
        # =
        CqlParser.new.equals.parse('=')
        expect(CqlParser.new.equals).to parse('=')
        expect(CqlParser.new.equals).to parse('= ')
        expect(CqlParser.new.equals).to parse('=   ')
        expect(CqlParser.new.equals).to parse(' =')
        expect(CqlParser.new.equals).to parse('  = ')
        expect(CqlParser.new.equals).to parse('   =   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse a queryable value' do
      begin
        # value for supported queryables
        CqlParser.new.value.parse('foo')
        CqlParser.new.value.parse('*bar*')
        CqlParser.new.value.parse('*baz?')
        expect(CqlParser.new.value).to parse('foo')
        expect(CqlParser.new.value).to parse('*bar*')
        expect(CqlParser.new.value).to parse('*baz?')
        expect(CqlParser.new.value).to parse('-90,-180,90,180')
        expect(CqlParser.new.value).to parse('1990-09-03T00:00:01Z')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the and operator' do
      begin
        # operator
        CqlParser.new.operator.parse('and')
        expect(CqlParser.new.operator).to parse('and')
        expect(CqlParser.new.operator).to parse('and ')
        expect(CqlParser.new.operator).to parse('and   ')
        expect(CqlParser.new.operator).to parse(' and')
        expect(CqlParser.new.operator).to parse('  and ')
        expect(CqlParser.new.operator).to parse('   and   ')
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the AnyText queryable and value' do
      begin
        # single queryable and value
        expect(CqlParser.new.cqlquery).to parse('AnyText=1234')
        expect(CqlParser.new.cqlquery).to parse(' AnyText = 1234')
        parser = CqlParser.new.cqlquery.parse(' AnyText = 1234')
        expect(parser[0][:key].str).to eq 'AnyText'
        expect(parser[0][:value].str).to eq '1234'
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the IsCwic queryable and value' do
      begin
        # single queryable and value
        expect(CqlParser.new.cqlquery).to parse('IsCwic=true')
        expect(CqlParser.new.cqlquery).to parse(' IsCwic = true')
        parser = CqlParser.new.cqlquery.parse(' IsCwic = true')
        expect(parser[0][:key].str).to eq 'IsCwic'
        expect(parser[0][:value].str).to eq 'true'
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the IsGeoss queryable and value' do
      begin
        # single queryable and value
        expect(CqlParser.new.cqlquery).to parse('IsGeoss=true')
        expect(CqlParser.new.cqlquery).to parse(' IsGeoss = true')
        parser = CqlParser.new.cqlquery.parse(' IsGeoss = true')
        expect(parser[0][:key].str).to eq 'IsGeoss'
        expect(parser[0][:value].str).to eq 'true'
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the TempExtent_begin queryable and value' do
      begin
        # single queryable and value
        expect(CqlParser.new.cqlquery).to parse('TempExtent_begin=1990-09-03T00:00:01Z')
        expect(CqlParser.new.cqlquery).to parse(' TempExtent_begin=1990-09-03T00:00:01Z')
        parser = CqlParser.new.cqlquery.parse(' TempExtent_begin=1990-09-03T00:00:01Z')
        expect(parser[0][:key].str).to eq 'TempExtent_begin'
        expect(parser[0][:value].str).to eq '1990-09-03T00:00:01Z'
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the TempExtent_end queryable and value' do
      begin
        expect(CqlParser.new.cqlquery).to parse('TempExtent_end=2008-09-06T23:59:59Z')
        expect(CqlParser.new.cqlquery).to parse(' TempExtent_end=2008-09-06T23:59:59Z')
        parser = CqlParser.new.cqlquery.parse(' TempExtent_end=2008-09-06T23:59:59Z')
        expect(parser[0][:key].str).to eq 'TempExtent_end'
        expect(parser[0][:value].str).to eq '2008-09-06T23:59:59Z'
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the AnyText and BoundingBox queryables and values' do
      begin
        # two queryables and values
        expect(CqlParser.new.cqlquery).to parse('AnyText=1234 and BoundingBox=-180,-90,+180.000,+90.0')
        expect(CqlParser.new.cqlquery).to parse(' AnyText =  1234 and   BoundingBox= -180,-90,+180.000,+90.0')
        parser = CqlParser.new.cqlquery.parse('AnyText=1234 and BoundingBox=-180,-90,+180.000,+90.0')
        expect(parser[0][:key].str).to eq 'AnyText'
        expect(parser[0][:value].str).to eq '1234'
        expect(parser[1][:key].str).to eq 'BoundingBox'
        expect(parser[1][:value].str).to eq '-180,-90,+180.000,+90.0'
      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the AnyText,BoundingBox, TempExtent_begin, TempExtent_end queryables and values' do
      begin
        # ALL queryables and values
        parser = CqlParser.new.cqlquery.parse('AnyText=1234 and BoundingBox=-180,-90,+180.000,+90.0 and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z')
        expect(parser[0][:key].str).to eq 'AnyText'
        expect(parser[0][:value].str).to eq '1234'
        expect(parser[1][:key].str).to eq 'BoundingBox'
        expect(parser[1][:value].str).to eq '-180,-90,+180.000,+90.0'
        expect(parser[2][:key].str).to eq 'TempExtent_begin'
        expect(parser[2][:value].str).to eq '1990-09-03T00:00:01Z'
        expect(parser[3][:key].str).to eq 'TempExtent_end'
        expect(parser[3][:value].str).to eq '2008-09-06T23:59:59Z'

        expect(CqlParser.new.cqlquery).to parse(' AnyText = 1234 and BoundingBox =  -180,-90,+180.000,+90.0 and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z')
        expect(CqlParser.new.cqlquery).to parse(' AnyText=  1234 and BoundingBox  =   -180,-90,+180.000,+90.0 and TempExtent_begin = 1990-09-03T00:00:01Z  and TempExtent_end  = 2008-09-06T23:59:59Z')

      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end

    it 'is possible to parse the AnyText,BoundingBox, TempExtent_begin, TempExtent_end, IsCwic, IsGeos queryables and values' do
      begin
        # ALL queryables and values
        parser = CqlParser.new.cqlquery.parse('AnyText=1234 and BoundingBox=-180,-90,+180.000,+90.0 and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z and IsCwic=true and IsGeoss=true')
        expect(parser[0][:key].str).to eq 'AnyText'
        expect(parser[0][:value].str).to eq '1234'
        expect(parser[1][:key].str).to eq 'BoundingBox'
        expect(parser[1][:value].str).to eq '-180,-90,+180.000,+90.0'
        expect(parser[2][:key].str).to eq 'TempExtent_begin'
        expect(parser[2][:value].str).to eq '1990-09-03T00:00:01Z'
        expect(parser[3][:key].str).to eq 'TempExtent_end'
        expect(parser[3][:value].str).to eq '2008-09-06T23:59:59Z'
        expect(parser[4][:key].str).to eq 'IsCwic'
        expect(parser[4][:value].str).to eq 'true'
        expect(parser[5][:key].str).to eq 'IsGeoss'
        expect(parser[5][:value].str).to eq 'true'

        expect(CqlParser.new.cqlquery).to parse(' AnyText = 1234 and BoundingBox =  -180,-90,+180.000,+90.0 and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008-09-06T23:59:59Z and IsCwic=true and IsGeoss=true')
        expect(CqlParser.new.cqlquery).to parse(' AnyText=  1234 and BoundingBox  =   -180,-90,+180.000,+90.0 and TempExtent_begin = 1990-09-03T00:00:01Z  and TempExtent_end  = 2008-09-06T23:59:59Z  and  IsCwic = true and IsGeoss = true')

      rescue Parslet::ParseFailed => error
        fail(error.cause.ascii_tree)
      end
    end
  end
end