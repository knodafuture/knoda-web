module PredictionsHelper
	def display_challenge_icon(prediction)
		if (current_user.id != prediction.user_id)
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
	end

	def display_close_status(prediction)
		if prediction.expires_at > Time.now
			return "closes #{distance_of_time_in_words_to_now(prediction.created_at)} from now"
		else
			return "closed #{distance_of_time_in_words_to_now(prediction.created_at)} ago"
		end
	end


	def display_result_outcome_icon(prediction)
		c = my_challenge(prediction)
		if c
			if c.agree
				image_tag("icons/ResultsWinIcon@2x.png")
			else
				image_tag("icons/ResultsLoseIcon@2x.png")
			end
		end
	end

	def display_result_outcome_text(prediction)
		c = my_challenge(prediction)
		if c
			if c.agree
				return "YOU WON!"
			else
				return "YOU LOST!"
			end
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

    def total_points(prediction)
	    if my_challenge(prediction)
	      my_challenge(prediction).total_points
	    end    	
    end
end
