window.unbindAll = () ->
  $("#twitter-share-button").unbind()


window.bindAll = () ->
  $('#twitter-share-button').click (e) ->
    startLoading()
    $.ajax
      url: "/predictions/#{$(e.currentTarget).attr('data-prediction-id')}/twitter_share.json"
      type: "POST"
      success: (json) =>
        stopLoading();
        $('.alerts').html("<div class=\"alert alert-success\">Thanks for sharing! The prediction has been posted to Twitter.</div>")

  $('#facebook-share-button').click (e) ->
    startLoading()
    $.ajax
      url: "/predictions/#{$(e.currentTarget).attr('data-prediction-id')}/facebook_share.json"
      type: "POST"
      success: (json) =>
        stopLoading();
        $('.alerts').html("<div class=\"alert alert-success\">Thanks for sharing! The prediction has been posted to Facebook.</div>")
$ ->
  bindAll()
