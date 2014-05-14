window.HomeView = class HomeView
  constructor: (options) ->
    @container = options.container
    $('.carousel').carousel()
    $('#user_email').focus()
    $('input').change (e) ->
      $(e.currentTarget).addClass('changed')
    $("a[href=#section-2], a[href=#section-1], a[href=#section-3], a[href=#section-4]").click (e) ->
      e.preventDefault()
      $("#{$(e.currentTarget).attr('href')}").ScrollTo()
    $('#section-3 .how1 div').vAlign();
    $('#section-3 .how2 div').vAlign();
    $('#section-3 .how3 div').vAlign();
    $('.section-4-content').vAlign();
    @simulateTyping()
    setInterval @simulateTyping, 7500

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
