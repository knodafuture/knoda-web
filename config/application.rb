require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module KnodaWeb
  class Application < Rails::Application
    config.paths['db/migrate'] = KnodaCore::Engine.paths['db/migrate'].existent
    config.action_dispatch.default_headers['X-Frame-Options'] = "GOFORIT"
    config.knoda_web_url = ENV['KNODA_WEB_URL'] || 'http://www.knoda.com'

    config.action_mailer.default_url_options = { :host => config.knoda_web_url }

    ENV['ELASTICSEARCH_URL'] = ENV['SEARCHBOX_URL'] || 'http://localhost:9200'

    config.allowRobots = ENV['ALLOW_ROBOTS'] || false

    config.analytics_enabled = ENV['ANALYTICS_ENABLED'] || false
    config.lucky_orange_enabled = ENV['LUCKY_ORANGE_ENABLED'] || false
    config.assets.debug = true
    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.precompile += %w(application-home.css)
    config.assets.precompile += %w(application-prelogin.css)
    config.assets.precompile += %w(application-embed.css)
    config.assets.precompile += %w(edge.3.0.0.min.js)
    config.twitter_key = "14fSb3CT7EEQkoryO8RNx7BrG"
    config.twitter_secret = "6Z5OGzxLL9NqVEpAbLs9FFd2PyLm6pd7j5r98IZr5e0HRr73bo"

    config.facebook_app_id = "455514421245892"
    config.facebook_app_secret = "34ad3fdfaa67ccd2a7dae8927501c7e3"

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
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['S3_BUCKET_NAME'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      }
    }
    puts config.paperclip_defaults
    Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
    Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
  end
end
