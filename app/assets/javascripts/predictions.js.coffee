createChallenge = (prediction_id, agree) ->
  $.ajax
    url: "/challenges.json"
    data:
      prediction_id: prediction_id
      agree: agree
    type: "POST"
    dataType: "json"
    success: (json) ->
      console.log json
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
      $('.commentsList li').first().prepend("<li>#{text}</li>")
      console.log json
    error: (xhr, status) ->
      console.log "Sorry, there was a problem!"
    complete: (xhr, status) ->
      console.log "The request is complete!"      




$ ->
  predictionId = $('#predictionRoot').attr('data-prediction-id')
  $('.agree').click (e) ->
    createChallenge(predictionId, true)
    e.preventDefault()

  $('.disagree').click (e) ->
    createChallenge(predictionId, false)
    e.preventDefault()

  $('.addCommentButton').click (e) ->
    comment(predictionId, $('.addCommentForm textarea').val())
    e.preventDefault()