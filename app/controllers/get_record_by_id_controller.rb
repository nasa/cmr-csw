class GetRecordByIdController < ApplicationController
  def index
    time = Benchmark.realtime do
      begin
        grbi = GetRecordById.new(params, request)
        if grbi.valid?
          @model = grbi.find
          render 'get_record_by_id/index.xml.erb', :status => :ok
        else
          @exceptions = []
          grbi.errors.each do |attribute, error|
            @exceptions.append OwsException.new(attribute, error)
          end
          render 'shared/exception_report.xml.erb', :status => :bad_request
        end
      end
    end
    request.body.rewind
    body = request.body.read
    unless @model.nil?
      number_of_records_matched = @model.number_of_records_matched
    else
      number_of_records_matched = 0
    end
    Rails.logger.info log_performance('GetRecordById', time, number_of_records_matched, body)
  end
end
