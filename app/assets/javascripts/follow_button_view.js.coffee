window.FollowButtonView = class FollowButtonView
  constructor: (@options) ->
    @bindAll()
  bindAll: ->
    $('.btn-follow').click @startFollowing
    $('.btn-following').click @stopFollowing
  unbindAll: ->
    $('.btn-follow').unbind()
    $('.btn-following').unbind()
  startFollowing: (e) =>
    startLoading()
    user_id = $(e.currentTarget).attr('data-user-id')
    $.ajax
      url: "/followings.json"
      type: "POST"
      data: {leader_id: user_id}
      success: (json) =>
        $(e.currentTarget).text('Following').removeClass('btn-follow').addClass('btn-following').attr('data-id', json.id)
        $(e.currentTarget).unbind().click @stopFollowing
        stopLoading()
  stopFollowing: (e) =>
    startLoading()
    $.ajax
      url: "/followings/#{$(e.currentTarget).attr('data-id')}.json"
      type: "DELETE"
      success: (json) =>
        $(e.currentTarget).text('Follow').removeClass('btn-following').addClass('btn-follow').removeAttr('data-id')
        $(e.currentTarget).unbind().click @startFollowing
        stopLoading()
