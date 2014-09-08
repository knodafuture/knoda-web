module FriendsHelper
  def find_header_text(friends, source)
    if friends
      if friends.size == 0
        return "None of your #{source.capitalize} friends are on Knoda. Invite your friends."
      else
        return "#{friends.size} of your #{source.capitalize} friends are on Knoda. Start following them to see all their predictions."
      end
    else
      return "None of your #{source.capitalize} friends are on Knoda. Invite your friends."
    end
  end
end
