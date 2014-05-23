$ ->
  $('.collapse').collapse(
    toggle: false
  )
  currentOffset = 0
  pageSize = 25
  loading = false
  container = $('#predictionsList')
  $(window).scroll ->
    if $(window).scrollTop() + $(window).height() is $(document).height() and not loading
      if $('.predictionContainer').length >= currentOffset + pageSize
        loading = true
        startLoading()
        tag = getUrlVars()["tag"]
        if tag
          url = "/predictions?tag=#{tag}&offset=#{currentOffset+pageSize}&limit=#{pageSize}"
        else
          url = "/predictions?offset=#{currentOffset+pageSize}&limit=#{pageSize}"
        $.ajax
          url: url
          type: "GET"
          success: (x) ->
            currentOffset = currentOffset + pageSize
            container.append($(x))
            loading = false
            unbindAll();
            bindAll();
          complete: (x) ->
            stopLoading()
