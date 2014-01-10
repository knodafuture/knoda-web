require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module KnodaWeb
  class Application < Rails::Application
    config.knoda_web_url = ENV['KNODA_WEB_URL'] || 'http://www.knoda.com'
    ENV['ELASTICSEARCH_URL'] = ENV['SEARCHBOX_URL'] || 'http://localhost:9200'    
    config.allowRobots = ENV['ALLOW_ROBOTS'] || false
  end
end
