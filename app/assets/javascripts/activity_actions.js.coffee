window.unbindAll = () ->
  $('.brag-prediction').unbind()

window.bindAll = () ->
  $('#sharePrediction').on 'hidden.bs.modal', ->
    $(this).removeData();
  $('.brag-prediction').click (e) ->
    e.stopPropagation()
    predictionId = $(e.target).parents('.activity-item').attr('data-prediction-id')
    $('#sharePrediction').modal
      remote : "/predictions/#{predictionId}/share_dialog"
  $('.activity-item').click (e) ->
    predictionId = $(e.target).parents('.activity-item').attr('data-prediction-id')
    userId = $(e.target).parents('.activity-item').attr('data-user-id')
    if predictionId
      window.location = "/predictions/#{predictionId}"
    else
      if userId
        window.location = "users/#{userId}"

$ ->
  bindAll()
