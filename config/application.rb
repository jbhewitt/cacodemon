require File.expand_path('../boot', __FILE__)

require 'rails/all'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cacodemon
  class Application < Rails::Application
    
    configatron.champion.sourcefiles = "/vagrant/cacodemon/public/champions"    
    configatron.working_dir = "/ram_disk"

    configatron.webserver = '192.168.10.172:6300' #change - app/assets/javascripts/application.js

    configatron.qlab.ip = '192.168.10.172'
    configatron.qlab.port = '53000'
    configatron.qlab.template = 'QLab Template.cues'
    configatron.qlab.sourcefiles = "/Users/jb/dev/cacodemon/cacodemon/public/champions"    
    

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end


