window.unbindAll = () ->
  $('button.brag-prediction').unbind()

window.bindAll = () ->
  $('#sharePrediction').on 'hidden.bs.modal', ->
    $(this).removeData();
  console.log $('button.brag-prediction')
  $('button.brag-prediction').click (e) ->
    console.log "brag please"
    predictionId = $(e.target).attr('data-prediction-id')
    $('#sharePrediction').modal
      remote : "/predictions/#{predictionId}/share_dialog"
$ ->
  console.log('im running')
  bindAll()
