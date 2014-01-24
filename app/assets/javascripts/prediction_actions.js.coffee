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