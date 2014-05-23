window.KnodaConnectView = class KnodaConnectView
  constructor: (options) ->
    @destination = options.destination
    $('.login').on 'click', @gotoLogin
    $('.connect-option-email a').on 'click', @gotoSignup
    $("#new_user").on "submit", @signup
    $("#login_form").on "submit", @login
    $('.back').on 'click', @gotoOptions
    $('.btn-facebook').on 'click', =>
      startLoading() if startLoading
    $('.btn-twitter').on 'click', =>
      startLoading() if startLoading

  gotoOptions: =>
    $('.connect-options').show()
    $('.signup-page').hide()
    $('.facebook-page').hide()
    $('.twitter-page').hide()
    $('.login-page').hide()
    $("#knoda_connect .alert").hide()

  gotoLogin: =>
    $('.connect-options').hide()
    $('.signup-page').hide()
    $('.facebook-page').hide()
    $('.twitter-page').hide()
    $('.login-page').show()
    $('#user_login').focus()

  gotoSignup: =>
    $('.connect-options').hide()
    $('.signup-page').show()
    $('.facebook-page').hide()
    $('.twitter-page').hide()
    $('.login-page').hide()
    $('#user_email').focus()

  login: (e) =>
    e.preventDefault()
    startLoading() if startLoading
    $.ajax
      url: "/signin.json"
      data: $("#login_form").serialize()
      type: "POST"
      success: (json, status) =>
        ga "send", "event", "users", "login"
        if (window.opener)
          window.opener.embedView.afterLogin()
          self.close()
        else
          window.location = "#{@destination}"
      error: (xhr, status) ->
        stopLoading() if stopLoading
        $("#knoda_connect .alert").show()
        $("#knoda_connect .alert ul").empty()
        $('#knoda_connect .alert .alertText').text("Whoa there, we couldn't log you in.  Check your username & password and try again.")


  signup: (e) =>
    e.preventDefault()
    startLoading() if startLoading
    $.ajax
      url: "/users.json"
      data: $("#new_user").serialize()
      type: "POST"
      dataType: "json"
      success: (json, status) =>
        ga "send", "event", "users", "signup"
        if (window.opener)
          window.opener.embedView.afterLogin()
          self.close()
        else
          window.location = json.location + "&destination=#{@destination}"
      error: (xhr, status) ->
        stopLoading() if stopLoading
        $("#knoda_connect .alert").show()
        $("#knoda_connect .alert ul").empty()
        $('#knoda_connect .alert .alertText').text("Hold on, your registration isn't ready yet.")
        for x of xhr.responseJSON.errors
          $("#knoda_connect .alert ul").append "<li>" + x + " " + xhr.responseJSON.errors[x][0]