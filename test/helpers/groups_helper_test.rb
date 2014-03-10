require 'test_helper'

class GroupsHelperTest < ActionView::TestCase
  include GroupsHelper
  test "should return the correct rank" do
    user1 = User.new
    user1.id = 1
    user2 = User.new
    user2.id = 2
    leaderboard = []
    leaderboard << {:rank => 1, :rankText => "1st of 2", :user => user2}
    leaderboard << {:rank => 2, :rankText => '2nd of 2', :user => user1}
    assert user_rank(user1, leaderboard) == '2nd of 2'
    assert user_rank(user2, leaderboard) == '1st of 2'
  end
end
