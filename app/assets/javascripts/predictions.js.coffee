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

$ ->

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

  if $('#predictions:index:container').length > 0 or $('#history:index:container').length > 0
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
          