window.KnodaConnectView = class KnodaConnectView
  constructor: (options) ->
    $('.login').on 'click', @gotoLogin
    $('.connect-option-email a').on 'click', @gotoSignup
    $("#new_user").on "submit", @signup
    $("#login_form").on "submit", @login
    $('.back').on 'click', @gotoOptions

  gotoOptions: =>
    $('.connect-options').show()
    $('.signup-page').hide()
    $('.facebook-page').hide()
    $('.twitter-page').hide()
    $('.login-page').hide()

  gotoLogin: =>
    $('.connect-options').hide()
    $('.signup-page').hide()
    $('.facebook-page').hide()
    $('.twitter-page').hide()
    $('.login-page').show()

  gotoSignup: =>
    $('.connect-options').hide()
    $('.signup-page').show()
    $('.facebook-page').hide()
    $('.twitter-page').hide()
    $('.login-page').hide()
    $('#user_email').focus()

  login: (e) =>
    e.preventDefault()
    $.ajax
      url: "/signin.json"
      data: $("#login_form").serialize()
      type: "POST"
      success: (json, status) =>
        window.opener.embedView.afterLogin()
        self.close()
      error: (xhr, status) ->
        $("#login_form .alert").show()

  signup: (e) =>
    e.preventDefault()
    #startLoading()
    $.ajax
      url: "/users.json"
      data: $("#new_user").serialize()
      type: "POST"
      dataType: "json"
      success: (json, status) =>
        window.opener.embedView.afterLogin()
        self.close()
      error: (xhr, status) ->
        $("#new_user .alert").show()
        $("#new_user .alert ul").empty()
        for x of xhr.responseJSON.errors
          $("#new_user .alert ul").append "<li>" + x + " " + xhr.responseJSON.errors[x][0]
