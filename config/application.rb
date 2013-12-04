require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module KnodaWeb
  class Application < Rails::Application
    config.assets.precompile += [
      'jquery.cycle.all.min.js',
      'rotating_tweet.js',
      'chunk.css',
      'rotating_tweets.css'
    ]    
    config.allowRobots = ENV['ALLOW_ROBOTS'] || false
  end
end
