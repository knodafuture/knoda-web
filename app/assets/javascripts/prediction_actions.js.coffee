createChallenge = (prediction_id, agree) ->
  $.ajax
    url: "/challenges.json"
    data:
      authenticity_token : $('meta[name=csrf-token]').attr('content')
      prediction_id: prediction_id
      agree: agree
    type: "POST"
    dataType: "json"
    success: (json) ->
      el = $(".predictionContainer[data-prediction-id=#{prediction_id}]")
      if agree
        el.find(".agree").addClass('active')
        el.find(".disagree").removeClass('active')
      else
        el.find(".agree").removeClass('active')
        el.find(".disagree").addClass('active')
      el.find(".agree-percentage").text(json.prediction_agree_percent)
      if el.find('.disagreeUsersList').length > 0
        loadTally(el, prediction_id)


comment = (prediction_id, text) ->
  if $.trim(text).length > 0
    startLoading()
    $.ajax
      url: "/comments"
      data:
        authenticity_token : $('meta[name=csrf-token]').attr('content')
        prediction_id: prediction_id
        text : text
      type: "POST"
      success: (comments) ->
        FlurryAgent.logEvent("CREATE_COMMENT")
        el = $(".predictionContainer[data-prediction-id=#{prediction_id}]")
        el.find(".comments-content").html(comments);
        unbindAll()
        bindAll()
        stopLoading()

close = (prediction_id, outcome) ->
  startLoading()
  $.ajax
    type: 'POST'
    url: "/predictions/#{prediction_id}/close.html"
    data:
      prediction :
        outcome: outcome
      authenticity_token : $('meta[name=csrf-token]').attr('content')
    success: (section2) ->
      el = $(".predictionContainer[data-prediction-id=#{prediction_id}]")
      el.find(".section-2").html(section2);
      if outcome
        el.find('.myChallenge').html("<span class='pull-right won-lost-indicator won'>W</span>")
      else
        el.find('.myChallenge').html("<span class='pull-right won-lost-indicator lost'>L</span>")
      stopLoading();

callBS = (prediction_id) ->
  if confirm("Don't be lame. Tell the truth. It's more fun this way. Is this really the wrong outcome?")
    $.ajax
      type: 'POST'
      url: "/predictions/#{prediction_id}/bs.json"
      dataType: "json"
      success: (json) ->
        FlurryAgent.logEvent("BS_BUTTON_TAPPED")
        window.location.reload()

loadTally = (el, prediction_id) ->
    $.ajax
      url: "/predictions/#{prediction_id}/tally"
      type: "GET"
      success: (html) ->
        el.find('.tally-content').html(html)
      complete: (xhr, status) ->
        stopLoading();

loadComments = (el, prediction_id) ->
    $.ajax
      url: "/predictions/#{prediction_id}/comments"
      type: "GET"
      success: (html) ->
        el.find('.comments-content').html(html)
      complete: (xhr, status) ->
        stopLoading();

window.updatePrediction = (prediction_id, body) ->
  $.ajax
    type: 'PUT'
    url: "/predictions/#{prediction_id}.json"
    dataType: "json"
    data: body
    success: (json) ->
      FlurryAgent.logEvent("UNFINISHED_BUTTON_TAPPED")
      window.location.reload()


window.unbindAll = () ->
  $('.yes').unbind()
  $('.no').unbind()
  $('.remind').unbind()
  $('.agree').unbind()
  $('.disagree').unbind()
  $('.addCommentButton').unbind()
  $('a.comments').unbind()
  $('a.tally').unbind()
  $('a.bs').unbind()
  $('a.share-prediction').unbind()


window.bindAll = () ->
  $('#sharePrediction').on 'hidden.bs.modal', ->
    $(this).removeData();
  $('textarea').maxlength
    alwaysShow: true

  $('.yes').click (e) ->
    e.preventDefault()
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    close(predictionId, true)

  $('.no').click (e) ->
    e.preventDefault()
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    close(predictionId, false)

  $('.remind').click (e) ->
    e.preventDefault()


  $('.agree').click (e) ->
    e.preventDefault()
    e.stopPropagation();
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    createChallenge(predictionId, true)
    FlurryAgent.logEvent("AGREE_BUTTON_TAPPED")

  $('.disagree').click (e) ->
    e.preventDefault()
    e.stopPropagation();
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    createChallenge(predictionId, false)
    FlurryAgent.logEvent("DISAGREE_BUTTON_TAPPED")


  $('.addCommentButton').click (e) ->
    el = $(e.target).parents('.predictionContainer')
    comment(el.attr('data-prediction-id'), el.find('.addCommentForm textarea').val())
    e.preventDefault()

  $('a.comments, .commentsText').click (e) ->
    e.preventDefault()
    el = $(e.target).parents('.predictionContainer')
    el.find('.tally-content').hide()
    el.find('.comments-content').show()
    el.find('a.comments').addClass('active')
    el.find('a.tally').removeClass('active')

  $('a.tally, .tallyText').click (e) ->
    e.preventDefault()
    el = $(e.target).parents('.predictionContainer')
    el.find('.tally-content').show()
    el.find('.comments-content').hide()
    el.find('a.tally').addClass('active')
    el.find('a.comments').removeClass('active')
    prediction_id = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    startLoading();
    loadTally(el, prediction_id);

  $('a.bs').click (e) ->
    e.preventDefault()
    el = $(e.target).parents('.predictionContainer')
    prediction_id = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    callBS(prediction_id)

  $('a.share-prediction').click (e) ->
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    groupId = $(e.target).parents('.predictionContainer').attr('data-group-id')
    if !groupId
      $('#sharePrediction').modal
        remote : "/predictions/#{predictionId}/share_dialog"
    else
      alert("Hold on, this is a private group prediction. You won't be be able to share it with the world.")

  $('#twitter-share-button').click (e) ->
    startLoading()
    $.ajax
      type: 'POST'
      url: "/tweets"
      data:
        prediction_id: predictionId
      complete: ->
        stopLoading();

  $('.predictionContainer p').each (element) ->
      $(this).html(linkHashtags($(this).html()));
      $(this).html(linkUserMentions($(this).html()));

  $('.predictionContainer .panel-heading').click (e) ->
    if ($(e.target).hasClass('hashtag') or $(e.target).hasClass('user-mention'))
      startLoading();
    else
      $(e.target).parents('.predictionContainer').find('.panel-body').slideToggle(350)

  $(".addCommentForm textarea").mentionsInput onDataRequest: (mode, query, callback, triggerChar) ->
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

$ ->
  bindAll()
