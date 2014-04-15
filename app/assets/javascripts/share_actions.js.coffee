window.unbindAll = () ->
  $("#twitter-share-button").unbind()


window.bindAll = () ->
  $('#twitter-share-button').click (e) ->
    startLoading()
    $.ajax
      type: 'POST'
      url: "/tweets"
      data:
        prediction_id: $(e.currentTarget).attr('data-prediction-id')
      success: (section2) ->
        console.log "woo!"
      error: (error) ->
        console.log error
      complete: ->
        stopLoading();

  $('#facebook-share-button').click (e) ->
    startLoading()
    $.ajax
      type: 'POST'
      url: "/facebook"
      data:
        prediction_id: $(e.currentTarget).attr('data-prediction-id')
      success: (section2) ->
        console.log "woo!"
      error: (error) ->
        console.log error
      complete: ->
        stopLoading();

$ ->
  bindAll()