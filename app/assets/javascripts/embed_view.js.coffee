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
