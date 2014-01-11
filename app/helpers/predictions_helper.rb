module PredictionsHelper
	def challenge_icon(prediction)
		c = my_challenge(prediction)
		if c
			if c.agree
				return image_tag("icons/AgreeMarker@2x.png")
			else
				return image_tag("icons/AgreeMarker@2x.png")
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
end
