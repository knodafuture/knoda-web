window.HomeView = class HomeView
  constructor: (options) ->
    @container = options.container
    @destination = options.destination
    $('.carousel').carousel()
    $('#user_email').focus()
    $('input').change (e) ->
      $(e.currentTarget).addClass('changed')
    @container.find('.tab-btn-signup').click =>
      @container.find('.tab-signup').show()
      @container.find('.tab-login').hide()
      @container.find('.tab-btn-login').removeClass('active')
      @container.find('.tab-btn-signup').addClass('active')      
      @container.find('#user_email').focus()
    @container.find('.tab-btn-login').click =>
      @container.find('.tab-login').show()
      @container.find('.tab-signup').hide()    
      @container.find('.tab-btn-signup').removeClass('active')
      @container.find('.tab-btn-login').addClass('active')
      @container.find('#user_login').focus()
    $(".signup").on "click", @submitSignup
    $("#new_user").on "submit", @submitSignup
    $("#login_form").on "submit", @login
    $("a[href=#section-2], a[href=#section-1], a[href=#section-3], a[href=#section-4]").click (e) ->
      e.preventDefault()
      $("#{$(e.currentTarget).attr('href')}").ScrollTo()     
    $('#section-3 .how1 div').vAlign(); 
    $('#section-3 .how2 div').vAlign(); 
    $('#section-3 .how3 div').vAlign(); 
    $('.section-4-content').vAlign();
    @simulateTyping()
    setInterval @simulateTyping, 7500
  submitSignup: (e) =>
    e.preventDefault()
    startLoading()
    $.ajax
      url: "/users.json"
      data: $("#new_user").serialize()
      type: "POST"
      dataType: "json"
      success: (json, status) =>
        ga "send", "event", "users", "signup"
        window.location = json.location + "&destination=#{@destination}"
      error: (xhr, status) ->
        $("#new_user .alert").show()
        $("#new_user .alert ul").empty()
        for x of xhr.responseJSON.errors
          $("#new_user .alert ul").append "<li>" + x + " " + xhr.responseJSON.errors[x][0]
  login: (e) =>
    e.preventDefault()
    startLoading()
    $.ajax
      url: "/signin.json"
      data: $("#login_form").serialize()
      type: "POST"
      success: (json, status) =>
        ga "send", "event", "users", "login"
        window.location = "#{@destination}"
      error: (xhr, status) ->
        $("#login_form .alert").show()

  simulateTyping: () =>
    element = $('#step1Text')
    console.log 'do it'
    element.empty()
    characters = "I will beat Carlos in Fantasy Football this week by at least 30 points."
    for num in [0..(characters.length-1)]
      @typeOneCharacter(element, characters[num], 75*num)

  typeOneCharacter: (element, character, delay) ->
    setTimeout ->
      element.text(element.text() + character)
    , delay