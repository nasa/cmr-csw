require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Csw
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.assets.initialize_on_precompile = false

    # for some reason the root_url rails variable always returns http even when running https
    # we use https everywhere except the development environment where we'll overwrite this setting with the http protocol
    config.action_controller.default_url_options = {
        :protocol => "https"
    }

    config.relative_url_root = '/csw'
    config.assets.prefix = '/assets'
    config.autoload_paths << Rails.root.join('/lib')

    def self.load_version
      version_file = "#{config.root}/version.txt"
      if File.exist?(version_file)
        return IO.read(version_file)
      elsif File.exist?('.git/config') && `which git`.size > 0
        version = `git rev-parse --abbrev-ref HEAD`
        return version
      end
      '(unknown)'
    end

    config.version = load_version
    # Configuration parameters for ALL environments

    # CMR API endpoint
    config.cmr_search_endpoint = 'https://cmr.earthdata.nasa.gov/search'
    # CMR tag for only CWIC granules
    config.cwic_tag = 'org.ceos.wgiss.cwic.granules.prod'
    config.cwic_descriptive_keyword = 'CWIC > CEOS WGISS Integrated Catalog'
    # CMR tag for GEOSS granules
    config.geoss_data_core_tag = 'org.geoss.geoss_data-core'
    config.geoss_data_core_descriptive_keyword_1 = 'geossDataCore'
    config.geoss_data_core_descriptive_keyword_2 = 'geossNoMonetaryCharge'
    # static CMR concept_id identifier for a CMR collection in the CMR PRODUCTION environment
    # the identifier is used to assemble the sample CMR CSW request in the documentation page:
    # https://cmr.earthdata.nasa.gov/csw/collections?request=GetRecordById&service=CSW&version=2.0.2&outputSchema=http://www.isotc211.org/2005/gmi&ElementSetName=full&id=C14758250-LPDAAC_ECS
    config.concept_id = 'C14758250-LPDAAC_ECS'

  end
end
