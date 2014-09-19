window.ContestsAdminView = class ContestsAdminView
  constructor: ->
    $('.agreeToTerms').on 'click', ->
      if $('#agreeToTermsCheckbox').prop('checked')
        $.ajax
          url: "/users/me/contest_agreement.json"
          data: {}
          type: "POST"
          dataType: "json"
          success: (json) =>
            $('#agreeToTermsModal').modal('hide')
      else
        $('.agreeToTermsGroup').addClass('has-error')
  require_agreement: ->
    $('#agreeToTermsModal').modal();
