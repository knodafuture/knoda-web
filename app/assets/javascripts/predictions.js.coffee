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

  $('.getMorePredictions').click (e) ->
    $.ajax
      url: "/predictions?offset=#{currentOffset+pageSize}"
      type: "GET"
      success: (x) ->
        currentOffset = currentOffset + pageSize
        $('table').append($(x))
        console.log $(x) 
      error: (xhr, status) ->
        console.log "Sorry, there was a problem!"
      complete: (xhr, status) ->
        console.log "The request is complete!"   

  if $('#index:container')
    $('.collapse').collapse(
      toggle: false
    )
    currentOffset = 0
    pageSize = 25
    loading = false
    container = $('table')
    $(window).scroll ->
      if $(window).scrollTop() + $(window).height() is $(document).height() and not loading
        loading = true
        $.ajax
          url: "/predictions?offset=#{currentOffset+pageSize}&limit=#{pageSize}"
          type: "GET"
          success: (x) ->
            currentOffset = currentOffset + pageSize
            container.append($(x))
            loading = false
          error: (xhr, status) ->
            console.log "Sorry, there was a problem!"
          complete: (xhr, status) ->
            console.log "The request is complete!"       
          