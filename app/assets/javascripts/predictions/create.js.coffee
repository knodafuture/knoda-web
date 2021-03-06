window.PredictionCreateView = class PredictionCreateView
  constructor: (@options) ->
    oneMinuteInFuture = moment().add('minutes', 1)
    twoMinutesInFuture = moment().add('minutes', 2)
    $('input[name=prediction_expires_at_date]').attr('min', oneMinuteInFuture.format('YYYY-MM-DD')).val(oneMinuteInFuture.format('YYYY-MM-DD'))
    $('input[name=prediction_expires_at_time]').val(oneMinuteInFuture.format('HH:mm:ss'))
    if (!Modernizr.inputtypes.date)
      $('input[type="date"]').inputDate();
    if (!Modernizr.inputtypes.time)
      $('input[type="time"]').inputTime()
    $(".share-twitter").on "click", @shareTwitter
    $(".share-facebook").on "click", @shareFacebook
    $("#new_prediction").on "submit", @submitPrediction
    $("input[name=prediction_expires_at_time], input[name=prediction_expires_at_date]").on "change", @changeDate
    $("textarea").maxlength alwaysShow: true
    $('.group_id').on 'change', =>
      gid = $('.group_id option:selected').val()
      if gid
        @disallowShare()
      else
        @allowShare()
    $('.help-text').popover({
        template: '<div class="popover help" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
      })

    $("textarea.mention").mentionsInput onDataRequest: (mode, query, callback, triggerChar) ->
      if triggerChar == '#'
        $.getJSON "/hashtags/autocomplete.json?q=#{query}", (data) ->
          if data.length > 0
            for i in [0..data.length-1]
              data[i] = {id: "#{triggerChar}#{data[i]}", name: "#{triggerChar}#{data[i]}", type: 'contact', trigger: triggerChar}
          callback.call this, data
      if triggerChar == '@'
        $.getJSON "/users/autocomplete.json?q=#{query}&nameOnly=true", (data) ->
          if data.length > 0
            for i in [0..data.length-1]
              data[i] = {id: "#{triggerChar}#{data[i]}", name: "#{triggerChar}#{data[i]}", type: 'contact', trigger: triggerChar}
          callback.call this, data


  allowShare: =>
    $('#new_prediction .prediction-share').show()

  disallowShare: =>
    $('#new_prediction .prediction-share').hide()


  shareTwitter: (e) =>
    e.preventDefault()
    if not twitter_account
      window.open $(e.currentTarget).attr("href"), "windowName", "height=300,width=325;status=0;toolbar=0;location=0;menubar=0;directories=0"
    else
      @onTwitterConnect()

  shareFacebook: (e) =>
    e.preventDefault()
    if not facebook_account
      window.open $(e.currentTarget).attr("href"), "windowName", "height=300,width=325;status=0;toolbar=0;location=0;menubar=0;directories=0"
    else
      @onFacebookConnect()

  onTwitterConnect: (e) =>
    $('.share-twitter').toggleClass('active')

  onFacebookConnect: (e) =>
    $('.share-facebook').toggleClass('active')

  onSocialConnectError: (msg) =>
    $('#new_prediction .alert p').hide()
    $("#new_prediction .alert").show()
    $("#new_prediction .alert ul").append "<li>" + msg + "</li>"

  submitPrediction: (e) =>
    e.preventDefault()
    @createPrediction()  if @validateNewPrediction()

  changeDate: (e) =>
    pe = moment($("input[name=prediction_expires_at_date]").val() + " " + $("input[name=prediction_expires_at_time]").val(), "YYYY-MM-DD HH:mm")
    $("#prediction_expires_at").val pe.toDate()


  clearValidation: =>
    $("#new_prediction .alert ul").empty()
    $("#new_prediction .alert").hide()
    $('#new_prediction .alert p').show()

  validateNewPrediction: =>
    @clearValidation()
    body = $.trim($("#new_prediction .body").val())
    category = $.trim($("#new_prediction .category option:selected").val())
    expires_at = moment($("#prediction_expires_at").val())
    errors = []
    errors.push msg: "Enter a short prediction."  if body is ""
    errors.push msg: "Choose a category."  if category is ""
    errors.push msg: "Choose a date for voting to end."  unless expires_at.isValid()
    errors.push msg: "Set a voting end date in the future."  if expires_at.isBefore(moment())
    if errors.length is 0
      true
    else
      $("#new_prediction .alert").show()
      for i of errors
        $("#new_prediction .alert ul").append "<li>" + errors[i].msg + "</li>"
      false

  createPrediction : =>
    startLoading()
    $.ajax
      url: "/predictions.json"
      data: $("#new_prediction").serialize()
      type: "POST"
      dataType: "json"
      success: (json) =>
        FlurryAgent.logEvent("CREATE_PREDICTION_SUCCESS")
        @prediction = json
        gid = $('.group_id option:selected').val()
        if not gid
          startLoading()
          @sharePrediction =>
            window.location.reload()
        else
          window.location.reload()

  sharePrediction: (onComplete) =>
    onComplete = onComplete || (->)
    async.parallel([
      (callback) =>
        if $('.share-twitter').hasClass('active')
          $.ajax
            url: "/predictions/#{@prediction.id}/twitter_share.json"
            type: "POST"
            success: (json) =>
              callback()
        else
          callback()
      (callback) =>
        if $('.share-facebook').hasClass('active')
          $.ajax
            url: "/predictions/#{@prediction.id}/facebook_share.json"
            type: "POST"
            success: (json) =>
              callback()
        else
          callback()
    ], onComplete)
