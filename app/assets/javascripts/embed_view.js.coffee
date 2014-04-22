window.EmbedView = class EmbedView
  constructor: (options) ->
    $('#embed-connect-modal').on 'shown.bs.modal', @bindModal
    @container = options.container
    $('.call-to-action').on 'click', @gotoKnoda
    $('.btn-agree').on 'click', @agree
    $('.btn-disagree').on 'click', @disagree
  bindModal: (e) =>
    @container.find('.tab-btn-signup').click =>
      @container.find('.tab-signup').show()
      @container.find('.tab-login').hide()
      @container.find('.tab-btn-login').removeClass('active')
      @container.find('.tab-btn-signup').addClass('active')      
      @container.find('#user_email').focus()
    @container.find('.tab-btn-login').click =>
      @container.find('.tab-login').show()
      @container.find('.tab-signup').hide()    
      @container.find('.tab-btn-signup').removeClass('active')
      @container.find('.tab-btn-login').addClass('active')
      @container.find('#user_login').focus()


  gotoKnoda: (e) =>
    window.open('http://www.knoda.com', 'windowName')

  createChallenge: (prediction_id, agree) ->
    $.ajax
      url: "/challenges.json"
      data:
        authenticity_token : $('meta[name=csrf-token]').attr('content')
        prediction_id: prediction_id
        agree: agree
      type: "POST"
      dataType: "json"
      success: (json) =>
        window.location.reload()
        @afterLogin = null

  agree: =>
    if @userId
      @createChallenge(@prediction.id, true)
    else
      @afterLogin = =>
        @createChallenge(@prediction.id, true)
      @showModal() 

  disagree: =>
    if @userId
      @createChallenge(@prediction.id, false)
    else
      @afterLogin = =>
        @createChallenge(@prediction.id, false)          
      @showModal() 

  showModal: =>
    window.open('/embed-login', 'windowName', 'height=300,width=325;status=0;toolbar=0;location=0;menubar=0;directories=0')  

window.EmbedLoginView = class EmbedLoginView
  constructor: (options) ->
    $('.login').on 'click', @gotoLogin
    $('.connect-option-email a').on 'click', @gotoSignup
    #$('.connect-option-facebook a').on 'click', @gotoFacebook
    #$('.connect-option-twitter a').on 'click', @gotoTwitter
    $("#new_user").on "submit", @signup
    $("#login_form").on "submit", @login
    $('.back').on 'click', @gotoOptions

  gotoOptions: =>
    $('.back').hide()
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
    $('.back').show()

  gotoFacebook: =>
    alert('Sorry, not working yet.')

  gotoTwitter: =>
    alert('Sorry, not working yet.')


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