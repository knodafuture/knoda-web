createChallenge = (prediction_id, agree) ->
  $.ajax
    url: "/challenges.json"
    data:
      prediction_id: prediction_id
      agree: agree
    type: "POST"
    dataType: "json"
    success: (json) ->
      if agree
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .agree").removeClass('userNotChosen').addClass('userAgrees')
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .disagree").removeClass('userDisagrees').addClass('userNotChosen')
      else
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .agree").removeClass('userAgrees').addClass('userNotChosen')
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .disagree").removeClass('userNotChosen').addClass('userDisagrees')      
    error: (xhr, status) ->
      console.log "Sorry, there was a problem!"
    complete: (xhr, status) ->
      console.log "The request is complete!"

comment = (prediction_id, text) ->
  $.ajax
    url: "/comments.json"
    data:
      prediction_id: prediction_id
      text : text
    type: "POST"
    dataType: "json"
    success: (json) ->
      el = $(".predictionContainer[data-prediction-id=#{prediction_id}]")
      el.find("ul.commentsList").append("<li>#{text}</li>");
      el.find(".addCommentForm textarea").val('')
    error: (xhr, status) ->
      console.log "Sorry, there was a problem!"
    complete: (xhr, status) ->
      console.log "The request is complete!"      

close = (prediction_id, outcome) ->
  $.ajax
    type: 'POST'
    url: "/predictions/#{prediction_id}/close.json"
    dataType: "json"
    data:
      prediction : 
        outcome: outcome
    success: (json) ->
      window.location.reload()

update = (prediction_id) ->
  $.ajax
    type: 'PUT'
    url: "/predictions/#{prediction_id}.json"
    dataType: "json"
    data:
      prediction : 
        resolution_date : moment().add('days', 7).toISOString()
    success: (json) ->
      console.log json
      window.location.reload()

$ ->
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
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    update(predictionId)   

  $('.agree').click (e) ->
    e.preventDefault()
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    createChallenge(predictionId, true)
    

  $('.disagree').click (e) ->
    e.preventDefault()
    predictionId = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    createChallenge(predictionId, false)
    

  $('.addCommentButton').click (e) ->
    el = $(e.target).parents('.predictionContainer')
    comment(el.attr('data-prediction-id'), el.find('.addCommentForm textarea').val())
    e.preventDefault()      

  $('a.comments').click (e) ->
    e.preventDefault()
    el = $(e.target).parents('.predictionContainer')
    el.find('.tally-content').hide()
    el.find('.comments-content').show()
    el.find('a.comments').addClass('active')
    el.find('a.tally').removeClass('active')

  $('a.tally').click (e) ->
    e.preventDefault()
    el = $(e.target).parents('.predictionContainer')
    el.find('.tally-content').show()
    el.find('.comments-content').hide()
    el.find('a.tally').addClass('active')
    el.find('a.comments').removeClass('active')    
    prediction_id = $(e.target).parents('.predictionContainer').attr('data-prediction-id')
    startLoading();
    $.ajax
      url: "/predictions/#{prediction_id}/tally"
      type: "GET"
      success: (html) ->
        el.find('.tally-content').html(html)
      error: (xhr, status) ->
        console.log "Sorry, there was a problem!"
      complete: (xhr, status) ->
        stopLoading();
        console.log "The request is complete!"   


