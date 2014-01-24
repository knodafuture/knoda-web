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
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .disagree").removeClass('userDisagress').addClass('userNotChosen')
      else
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .agree").removeClass('userAgrees').addClass('userNotChosen')
        $(".predictionContainer[data-prediction-id=#{prediction_id}] .disagree").removeClass('userNotChosen').addClass('userDisagrees')      
    error: (xhr, status) ->
      console.log "Sorry, there was a problem!"
    complete: (xhr, status) ->
      console.log "The request is complete!"

$ ->
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

  $('.collapse').collapse(
    toggle: false
  )
  currentOffset = 0
  pageSize = 25
  loading = false
  container = $('#predictionsList')
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