$ ->
  console.log 'hi'
  $("input.datepicker").each (i) ->
    console.log i
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "mm/dd/yy"