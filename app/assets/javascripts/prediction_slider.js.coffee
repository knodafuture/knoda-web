window.PredictionSliderView = class PredictionSliderView
  constructor: (options) ->
    @el = options.container
    @startCycle()    

  startCycle: =>
    @cycleOne()
    setInterval @cycleOne, 5000

  cycleOne: =>
    a = @el.find('.home-prediction:visible')
    if a.length > 0
      a.fadeOut
        duration: 'slow'
        complete: =>
          a.hide()
          if (a.next().length > 0)
            next = a.next()
          else
            next = @el.find('.home-prediction').first()
          next.fadeIn('slow')  
    else
      next = @el.find('.home-prediction').first()
      next.fadeIn('slow')