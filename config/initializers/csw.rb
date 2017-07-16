# Read configuration:
#  - If set, the SHELL environment variable value takes precedence over the Rails.configuration specific values
def load_config_parameter_value(config_parameter_name)
  config_parameter_value = ENV[config_parameter_name]
  if(config_parameter_value == nil)
    config_parameter_value = Rails.configuration.send(config_parameter_name)
  end
  unless config_parameter_value
    err_msg = "Could not find a value for configuration parameter '#{config_parameter_value}' in the environment or Rails.configuration"
    puts err_msg
    Rails.logger.error(err_msg)
  end
  return config_parameter_value
end
