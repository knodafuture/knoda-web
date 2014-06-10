window.badges = {
  showUnseenBadges : ->
    $.ajax
      type: "GET"
      url: "/badges?unseen=true&modal=true"
      success: (content) ->
        $('#badge-modal-container').html(content)

  checkBadges : (options) ->
    $.ajax
      type: "GET"
      url: "/badges.json?unseen=true"
      success: (content) ->
        if content.length > 0
          options.onUnseen()

  checkAndShow : ->
    @checkBadges
      onUnseen: =>
        @showUnseenBadges()
}

$ ->
  do badges.checkAndShow
