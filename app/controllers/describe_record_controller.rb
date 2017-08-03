class DescribeRecordController < ApplicationController
  def index
    time = Benchmark.realtime do
      # Switch on schema requested
      dr = DescribeRecord.new(params, request)
      if dr.valid?
        @describe_record_model = dr.get_model
        render 'describe_record/index.xml.erb', :status => :ok
      else
        @exceptions = []
        dr.errors.each do |attribute, error|
          @exceptions.append OwsException.new(attribute, error)
        end
        render 'shared/exception_report.xml.erb', :status => :bad_request
      end
    end
    request.body.rewind
    body = request.body.read
    Rails.logger.info log_performance('DescribeRecord', time, nil, body)
  end
end
