window.UserShowView = class UserShowView
  loading: false
  currentOffset: 0
  pageSize: 25
  constructor: (@options) ->
    @historyContainer = @options.historyContainer
    $('.btn-follow').click @startFollowing
    $('.btn-following').click @stopFollowing
    if (@options.history == 'votes')
      $('.history-tabs a.votes').addClass('active')
    else
      $('.history-tabs a.predictions').addClass('active')
    $('.social-account-destroy').on 'click', (e) =>
      e.preventDefault()
      if not @options.user.email and @options.social_accounts.length == 1
        alert('Please make sure you have an email address and password before deleting your social signin.')
        $('#collapseUsername').collapse('show')
      else
        if confirm('Are you sure you want to disconnect your account from Knoda?')
          startLoading()
          $.ajax
            url: "/social_accounts/#{$(e.currentTarget).attr('data-id')}.json"
            type: "DELETE"
            success: (json) ->
              window.location.reload()
    $(window).scroll =>
      if $(window).scrollTop() + $(window).height() is $(document).height() and not @loading
        if $('.predictionContainer').length >= @currentOffset + @pageSize
          loading = true
          startLoading()
          $.ajax
            url: "/users/#{@options.user.username}/history?offset=#{@currentOffset+@pageSize}&limit=#{@pageSize}&history=#{@options.history}"
            type: "GET"
            success: (x) =>
              @currentOffset = @currentOffset + @pageSize
              @historyContainer.append($(x))
              loading = false
              unbindAll()
              bindAll()
            complete: (xhr, status) ->
              stopLoading()
  startFollowing: (e) =>
    startLoading()
    $.ajax
      url: "/followings.json"
      type: "POST"
      data: {leader_id: @options.user.id}
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
