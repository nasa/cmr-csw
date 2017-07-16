class GetDomainController < ApplicationController

  def index
    time = Benchmark.realtime do
      begin
        @model = GetDomain.new(params, request)
        if @model.valid?
          @model.process_domain
          render 'get_domain/index.xml.erb', :status => :ok
        else
          @exceptions = []
          @model.errors.each do |attribute, error|
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

    Rails.logger.info log_performance('GetDomain', time, nil, body)
  end
end
