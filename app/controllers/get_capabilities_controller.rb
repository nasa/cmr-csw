class GetCapabilitiesController < ApplicationController

  def index
    time = Benchmark.realtime do
      gc = GetCapability.new(params, request)
      @get_capabilities_model = gc.get_model
      if gc.valid?
        render 'get_capabilities/index.xml.erb', :status => :ok
      else
        @exceptions = []
        gc.errors.each do |attribute, error|
          @exceptions.append OwsException.new(attribute, error)
        end
        render 'shared/exception_report.xml.erb', :status => :bad_request
      end
    end
    request.body.rewind
    body = request.body.read
    Rails.logger.info log_performance('GetCapabilities', time, nil, body)
  end
end

