class RobotsController < ApplicationController
  def robots
    allowRobots = Rails.application.config.allowRobots
    if allowRobots
      robots = File.read(Rails.root + "config/robots/allow.txt")  
    else
      robots = File.read(Rails.root + "config/robots/disallow.txt")  
    end
    render :text => robots, :layout => false, :content_type => "text/plain" 
  end
end
