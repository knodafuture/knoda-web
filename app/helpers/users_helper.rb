module UsersHelper

		def vs_my_win_percentage(vs)
			if vs[:user_won] == 0
				myPercentage = 0
			else
				myPercentage = vs[:user_won].fdiv((vs[:user_won] + vs[:opponent_won]))* 100
			end
			return myPercentage
		end

		def vs_opponent_win_percentage(vs)
			if vs[:opponent_won] == 0
				opponentPercentage = 0
			else
				opponentPercentage = vs[:opponent_won].fdiv((vs[:user_won] + vs[:opponent_won]))* 100
			end
			return opponentPercentage
		end

		def vs_my_bar_width(vs)
			if vs[:user_won] == 0
				myPercentage = 100
			else
				myPercentage = vs[:user_won].fdiv((vs[:user_won] + vs[:opponent_won]))* 100
			end
			return myPercentage
		end

		def vs_opponent_bar_width(vs)
			if vs[:opponent_won] == 0
				opponentPercentage = 100
			else
				opponentPercentage = vs[:opponent_won].fdiv((vs[:user_won] + vs[:opponent_won]))* 100
			end
			return opponentPercentage
		end

		def win_percentage(user)
			if (user.won + user.lost) > 0
				return "#{(user.won.fdiv(user.won + user.lost) * 100).round(2)}%"
			else
				return "0%"
			end
		end

		def win_percentage_status(user1, user2)
			if (user1.winning_percentage > user2.winning_percentage)
				return "winner"
			else
				return "loser"
			end
		end

		def streak_status(user1, user2)
			if (user1.streak > user2.streak)
				return "winner"
			else
				return "loser"
			end
		end
end
