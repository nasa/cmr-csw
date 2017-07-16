class GetRecordsController < ApplicationController
  def index
    time = Benchmark.realtime do
      begin
        gr = GetRecords.new(params, request)
        if gr.valid?
          @model = gr.find
          render 'get_records/index.xml.erb', :status => :ok
        else
          @exceptions = []
          gr.errors.each do |attribute, error|
            @exceptions.append OwsException.new(attribute, error)
          end
          render 'shared/exception_report.xml.erb', :status => :bad_request
        end
      rescue OwsException => e
        # exception not captured via the ActiveModel:Validation framework
        @exceptions = []
        @exceptions.append e
        render 'shared/exception_report.xml.erb', :status => :bad_request
      end
    end
    request.body.rewind
    body = request.body.read
    unless @model.nil?
      number_of_records_matched = @model.number_of_records_matched
    else
      number_of_records_matched = 0
    end

    Rails.logger.info log_performance('GetRecords', time, number_of_records_matched, body)
  end
end

