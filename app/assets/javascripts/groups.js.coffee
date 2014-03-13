window.GroupsView = class GroupsView
  invitees: []
  group_id: 0
  create :  ->
    startLoading()
    $.ajax
      url: "/groups.json"
      data: $("#new_group").serialize()
      type: "POST"
      dataType: "json"
      success: (json) ->
        startLoading()
        window.location = "/groups/#{json.id}"
  addInvitee: (user) ->     
    if user.username
      labelText = user.username
    else
      labelText = user.email
    $('.invitees').append("<div class='label label-default'>#{labelText}</div>")
    @invitees.splice 0, 0, user
    console.log @invitees
  search: _.throttle( ->
      q = $('#query').val()
      if (q.length > 2)
        $.ajax
          url: '/users/autocomplete?query=' + q
          type: "GET"
          success: (x) =>
            $('.matches').empty()
            for m in x
              l = $(document.createElement('li')).html(m.username).data('d', m)
              $(l).click (e) =>
                @addInvitee($(e.currentTarget).data('d'))
              $('.matches').append(l)
            if @isEmail($.trim(q))
              l = $(document.createElement('li')).html(q).data('d', {email: q})
              $(l).click (e) =>
                @addInvitee($(e.currentTarget).data('d'))
              $('.matches').append(l)
    ,500)
  inviteUsers: ->
    invitations = []
    for i in @invitees
      invitation = {group_id : @group_id}
      if (i.id)
        invitation.recipient_user_id = i.id
      else
        invitation.recipient_email = i.email
      invitations.splice 0, 0, invitation
    $.ajax
      url: "/invitations.json"
      type: "POST"
      contentType: "application/json"
      data: JSON.stringify(invitations)
      dataType: "json"
      success: (x) =>
        $('#query').empty()
        $('.matches').empty()
        $('.invitees').empty()
        @invitees = []
  initializeSearch: ->
    $('#query').keyup (e) =>
      @search(e)
  isEmail: (email) ->
    /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.test email  

window.JoinGroupView = class JoinGroupView 
  constructor: (group_id, code) ->
    @group_id = group_id
    @code = code
    $('.joinButton').click @submitMembership
  submitMembership: (e) =>
    e.preventDefault()
    console.log 'join group'
    $.ajax
      url: "/memberships.json"
      type: "POST"
      data: 
        membership : 
          group_id : @group_id
          code: @code        
        authenticity_token : $('meta[name=csrf-token]').attr('content')      
      dataType: "json"
      success: (x) =>
        window.location = "/groups/#{@group_id}"