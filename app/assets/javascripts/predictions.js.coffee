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


$ ->
  $('.agree').click (e) ->
    createChallenge(40, true)
    e.preventDefault()


  $('.disagree').click (e) ->
    createChallenge(40, false)
    e.preventDefault()