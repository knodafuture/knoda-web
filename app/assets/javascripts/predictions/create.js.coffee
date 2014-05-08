window.PredictionCreateView = class PredictionCreateView
  constructor: (@options) ->
    oneMinuteInFuture = moment().add('minutes', 1)
    twoMinutesInFuture = moment().add('minutes', 2)
    $('input[name=prediction_expires_at_date]').attr('min', oneMinuteInFuture.format('YYYY-MM-DD')).val(oneMinuteInFuture.format('YYYY-MM-DD'))
    $('input[name=prediction_expires_at_time]').val(oneMinuteInFuture.format('HH:mm:ss'))
    $('input[name=prediction_resolution_date_date]').attr('min', twoMinutesInFuture.format('YYYY-MM-DD')).val(twoMinutesInFuture.format('YYYY-MM-DD'))
    $('input[name=prediction_resolution_date_time]').val(twoMinutesInFuture.format('HH:mm:ss'))
    if (!Modernizr.inputtypes.date)
      $('input[type="date"]').inputDate();
    if (!Modernizr.inputtypes.time)
      $('input[type="time"]').inputTime()
    $(".share-twitter").on "click", @shareTwitter
    $(".share-facebook").on "click", @shareFacebook
    $("#new_prediction").on "submit", @submitPrediction
    $("input[name=prediction_resolution_date_time], input[name=prediction_resolution_date_date], input[name=prediction_expires_at_time], input[name=prediction_expires_at_date]").on "change", @changeDate
    $("textarea").maxlength alwaysShow: true


  shareTwitter: (e) =>
    e.preventDefault()
    if not twitter_account
      window.onTwitterConnect = @twitterConnected
      window.open $(e.currentTarget).attr("href"), "windowName", "height=300,width=325;status=0;toolbar=0;location=0;menubar=0;directories=0"
    else
      $('.share-twitter').toggleClass('active')

  shareFacebook: (e) =>
    e.preventDefault()
    if not facebook_account
      window.onTwitterConnect = @facebookConnected
      window.open $(e.currentTarget).attr("href"), "windowName", "height=300,width=325;status=0;toolbar=0;location=0;menubar=0;directories=0"
    else
      @facebookConnected()

  twitterConnected: (e) =>
    $('.share-twitter').toggleClass('active')

  facebookConnected: (e) =>
    $('.share-facebook').toggleClass('active')

  submitPrediction: (e) =>
    e.preventDefault()
    @createPrediction()  if @validateNewPrediction()

  changeDate: (e) =>
    pe = moment($("input[name=prediction_expires_at_date]").val() + " " + $("input[name=prediction_expires_at_time]").val(), "YYYY-MM-DD HH:mm")
    $("#prediction_expires_at").val pe.toDate()
    rd = moment($("input[name=prediction_resolution_date_date]").val() + " " + $("input[name=prediction_resolution_date_time]").val(), "YYYY-MM-DD HH:mm")
    $("#prediction_resolution_date").val rd.toDate()


  clearValidation: =>
    $("#new_prediction .alert ul").empty()
    $("#new_prediction .alert").hide()

  validateNewPrediction: =>
    @clearValidation()
    body = $.trim($("#new_prediction .body").val())
    category = $.trim($("#new_prediction .category option:selected").val())
    expires_at = moment($("#prediction_expires_at").val())
    resolution_date = moment($("#prediction_resolution_date").val())
    errors = []
    errors.push msg: "Enter a short prediction."  if body is ""
    errors.push msg: "Choose a category."  if category is ""
    errors.push msg: "Choose a date for voting to end."  unless expires_at.isValid()
    errors.push msg: "Choose a date for to resolve your prediction."  unless resolution_date.isValid()
    errors.push msg: "Set a resolution date after the voting ends."  if resolution_date.isBefore(expires_at)
    errors.push msg: "Set a voting end date in the future."  if expires_at.isBefore(moment())
    errors.push msg: "Set a resolution date in the future."  if resolution_date.isBefore(moment())
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
        @prediction = json
        console.log @prediction
        startLoading()
        @sharePrediction =>
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
