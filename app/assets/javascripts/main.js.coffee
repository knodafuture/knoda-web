createPrediction = () ->
  $.ajax
    url: "/predictions.json"
    data: $('#new_prediction').serialize()
    type: "POST"
    dataType: "json"
    success: (json) ->
      window.location.reload()
    error: (xhr, status) ->
      console.log "Sorry, there was a problem!"
    complete: (xhr, status) ->
      console.log "The request is complete!"      