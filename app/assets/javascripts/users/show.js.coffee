$ ->
  $('#edit_user').on 'submit', (e) ->
    e.preventDefault()
    startLoading()
    $.ajax
      url: "/users/me.json"
      data: $("#edit_user").serialize()
      type: "POST"
      dataType: "json"
      success: (json) ->
        stopLoading()
        window.location.reload()
      error: (xhr, status) ->
        stopLoading()
        $('#edit_user .alert').show()
        $('#edit_user .alert ul').empty()
        errors = xhr.responseJSON
        for i in _.keys(errors)
          $('#edit_user .alert ul').append("<li>#{i} #{errors[i][0]}</li>")

  $('#edit_user_password').on 'submit', (e) ->
    e.preventDefault()
    $.ajax
      url: "/user/update_password.json"
      data: $("#edit_user_password").serialize()
      type: "POST"
      dataType: "json"
      success: (json) ->
        stopLoading()
        window.location.reload()
      error: (xhr, status) ->
        stopLoading()
        $('#edit_user_password .alert').show()
        $('#edit_user_password .alert ul').empty()
        errors = xhr.responseJSON
        for i in _.keys(errors)
          $('#edit_user_password .alert ul').append("<li>#{i} #{errors[i][0]}</li>")