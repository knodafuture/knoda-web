window.EmbedView = class EmbedView
  constructor: (options) ->
    $('#embed-connect-modal').on 'shown.bs.modal', @bindModal
    @container = options.container
    $('.call-to-action').on 'click', @gotoKnoda
    $('.btn-agree').on 'click', @agree
    $('.btn-disagree').on 'click', @disagree
    if (($('body').height() - 20) > $(window).height())
      $('.prediction-meta').remove()

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
      @afterLogin = (options)=>
        @createChallenge(@prediction.id, true)
        @logAnalytics(options)
      @showModal()

  disagree: =>
    if @userId
      @createChallenge(@prediction.id, false)
    else
      @afterLogin = (options) =>
        @createChallenge(@prediction.id, false)
        @logAnalytics(options)
      @showModal()

  showModal: =>
    window.view2 = {hi: 'hi'}
    height = 300
    width = 325
    left = ($(window).width()/2)-(width/2);
    top = ($(window).height()/2)-(height/2);
    window.open("/embed-login", 'windowName', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=#{width}, height=#{height}, top=#{top}, left=#{left}")

  logAnalytics: (options) =>
    if options
      FlurryAgent.setUserId(options.user_id) if options.user_id
      FlurryAgent.logEvent(options.ANALYTICS_EVENT) if options.ANALYTICS_EVENT
