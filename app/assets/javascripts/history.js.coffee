$ ->
  currentOffset = 0
  pageSize = 25
  loading = false
  container = $('#historyList')
  $(window).scroll ->
    if $(window).scrollTop() + $(window).height() is $(document).height() and not loading
      if $('.predictionContainer').length >= currentOffset + pageSize
        loading = true
        startLoading()
        $.ajax
          url: "/history?offset=#{currentOffset+pageSize}&limit=#{pageSize}"
          type: "GET"
          success: (x) ->
            currentOffset = currentOffset + pageSize
            container.append($(x))
            loading = false
            unbindAll()
            bindAll()
          complete: (xhr, status) ->
            stopLoading()
