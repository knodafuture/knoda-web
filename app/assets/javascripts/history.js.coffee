$ ->
  currentOffset = 0
  pageSize = 25
  loading = false
  container = $('#historyList')
  $(window).scroll ->
    if $(window).scrollTop() + $(window).height() is $(document).height() and not loading
      loading = true
      startLoading()
      $.ajax
        url: "/history?offset=#{currentOffset+pageSize}&limit=#{pageSize}"
        type: "GET"
        success: (x) ->
          currentOffset = currentOffset + pageSize
          container.append($(x))
          loading = false
          stopLoading()
        error: (xhr, status) ->
          console.log "Sorry, there was a problem!"
        complete: (xhr, status) ->
          console.log "The request is complete!"       