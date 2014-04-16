require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module KnodaWeb
  class Application < Rails::Application
    config.paths['db/migrate'] = KnodaCore::Engine.paths['db/migrate'].existent
    config.middleware.use Rack::Deflater    
    config.knoda_web_url = ENV['KNODA_WEB_URL'] || 'http://www.knoda.com'
    
    config.action_mailer.default_url_options = { :host => config.knoda_web_url }

    ENV['ELASTICSEARCH_URL'] = ENV['SEARCHBOX_URL'] || 'http://localhost:9200'    
    
    config.allowRobots = ENV['ALLOW_ROBOTS'] || false

    config.analytics_enabled = ENV['ANALYTICS_ENABLED'] || false
    config.lucky_orange_enabled = ENV['LUCKY_ORANGE_ENABLED'] || false
    config.assets.debug = true
    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.precompile += %w(application-home.css)
    config.assets.precompile += %w(edge.3.0.0.min.js)
    config.assets.precompile << Proc.new do |path|
      puts path
      if path =~ /\.(js)\z/
        full_path = Rails.application.assets.resolve(path).to_path
        app_assets_path = Rails.root.join('app', 'assets').to_path
        if full_path.starts_with? app_assets_path
          puts "including asset: " + full_path
          true
        else
          puts "excluding asset: " + full_path
          false
        end
      else
        false
      end
    end
  end
end
