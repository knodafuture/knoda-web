window.EmbedView = class EmbedView
  constructor: (options) ->
    $('.call-to-action').on 'click', @gotoKnoda
    $('.btn-agree').on 'click', @agree
    $('.btn-disagree').on 'click', @disagree
    if (($('body').height() - 20) > $(window).height())
      $('.prediction-meta').remove()

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

  agree: (e) =>
    prediction_id = $(e.target).parents('.prediction-item').attr('data-prediction-id')
    if @userId
      @createChallenge(prediction_id, true)
    else
      @afterLogin = (options)=>
        @createChallenge(prediction_id, true)
        @logAnalytics(options)
      @showModal()

  disagree: (e) =>
    prediction_id = $(e.target).parents('.prediction-item').attr('data-prediction-id')
    if @userId
      @createChallenge(prediction_id, false)
    else
      @afterLogin = (options) =>
        @createChallenge(prediction_id, false)
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
