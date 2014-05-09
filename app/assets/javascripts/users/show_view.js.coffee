window.UserShowView = class UserShowView
  constructor: (@options) ->
    $('.social-account-destroy').on 'click', (e) =>
      e.preventDefault()
      if not @options.user.email and @options.social_accounts.length == 1
        alert('Please make sure you have an email address and password before deleting your social signin.')
        $('#collapseUsername').collapse('show')
      else
        startLoading()
        $.ajax
          url: "/social_accounts/#{$(e.currentTarget).attr('data-id')}.json"
          type: "DELETE"
          success: (json) ->
            window.location.reload()
