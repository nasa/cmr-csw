require "gc_disabler"

# this profile is to be used for profiling the CSW application.  It is almost identical with the production profile so
# that we can profile with production settings.
# See config.ru for current profile environment settings
Rails.application.configure do
  # disable garbage collection BEFORE profiling
  config.middleware.insert_before Rack::Runtime, GCDisabler

  # Code is not reloaded between requests.
  config.cache_classes = true
  config.cache_template_loading = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true
  config.assets.precompile =  %w[*.js *.css *.css.erb *.png *.jpg *.jpeg *.gif]
  config.assets.prefix = '/csw/assets'


  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

end
