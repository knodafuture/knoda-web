window.unbindAll = () ->
  $('.brag-prediction').unbind()

window.bindAll = () ->
  $('#sharePrediction').on 'hidden.bs.modal', ->
    $(this).removeData();
  $('.brag-prediction').click (e) ->
    predictionId = $(e.target).attr('data-prediction-id')
    $('#sharePrediction').modal
      remote : "/predictions/#{predictionId}/share_dialog"
$ ->
  bindAll()
