class ApplicationController < ActionController::Base
  protect_from_forgery

  def log_performance(method, time, number_of_records = nil, body = nil)
    log = "#{method} request with parameters #{params_to_logging(params)}"
    unless body.empty?
      log.concat(" and body \n#{body.force_encoding('UTF-8')}\n")
    end
    log.concat(" took #{(time.to_f * 1000).round(0)} ms")
    unless number_of_records.nil?
      log.concat(" and returned #{number_of_records} hit")
      log.concat('s') if number_of_records == 0 || number_of_records > 1
    end
    log
  end

  def params_to_logging(params)
    params.delete('controller')
    params.delete('action')
    params
  end
end
