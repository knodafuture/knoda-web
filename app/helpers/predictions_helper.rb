module PredictionsHelper
	def display_challenge_icon(prediction)
		c = my_challenge(prediction)
		if c
			if c.agree
				render :partial => "predictions/display_challenge", :locals => {:disagreeClass => 'userNotChosen', :agreeClass => 'userAgrees'}
			else
				render :partial => "predictions/display_challenge", :locals => {:disagreeClass => 'userDisagrees', :agreeClass => 'userNotChosen'}
			end
		else
			puts 'render time'
			render :partial => "predictions/display_challenge", :locals => {:disagreeClass => 'userNotChosen', :agreeClass => 'userNotChosen'}
		end
	end


	def my_challenge(prediction)
	    l = prediction.challenges.select { |c| c.user_id == current_user.id}
	    if l.length > 0
	      return l[0]
	    else
	      return nil
    end
  end
end
