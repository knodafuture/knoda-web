window.groups = {
  create :  ->
    startLoading()
    $.ajax
      url: "/groups.json"
      data: $("#new_group").serialize()
      type: "POST"
      dataType: "json"
      success: (json) ->
        startLoading()
        console.log json
        window.location = "/groups/#{json.id}"
      error: (xhr, status) ->
        console.log "Sorry, there was a problem!"
      complete: (xhr, status) ->
        console.log "The request is complete!"
}