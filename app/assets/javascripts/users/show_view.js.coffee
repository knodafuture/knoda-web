window.UserShowView = class UserShowView
  constructor: (options) ->
    $('.social-account-destroy').on 'click', (e) =>
      e.preventDefault()
      startLoading()
      $.ajax
        url: "/social_accounts/#{$(e.currentTarget).attr('data-id')}.json"
        type: "DELETE"
        success: (json) ->
          console.log json
          stopLoading()
          window.location.reload()
