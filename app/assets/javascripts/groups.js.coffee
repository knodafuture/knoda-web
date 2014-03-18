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
  search: _.throttle( ->
      createMatchElement = (m) ->
        imageUrl = m.avatar_image?.small || 'http://placehold.it/100x100'
        l = $(document.createElement('div'))
        l.addClass('col-sm-4 col-md-3')
        l.html "<div class=\"thumbnail\">
          <img src=\"#{imageUrl}\">
          <div class=\"caption\">
            <p style=\"text-overflow:ellipsis;overflow:auto;font-size:0.75em\">#{m.username}</p>
          </div>
        </div>"
        l.data('d', m)        
        return l  
      q = $('#query').val()
      if (q.length > 2)
        $.ajax
          url: '/users/autocomplete?query=' + q
          type: "GET"
          success: (x) =>
            $('.matches').empty()
            for m in x
              l = createMatchElement(m)
              $(l).click (e) =>
                @addInvitee($(e.currentTarget).data('d'))
                $(e.currentTarget).remove()
              $('.matches').append(l)
            if @isEmail($.trim(q))
              l = createMatchElement({email: q, username: q})
              $(l).click (e) =>
                @addInvitee($(e.currentTarget).data('d'))
                $(e.currentTarget).remove()
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

window.GroupSettingsView = class GroupSettingsView
  constructor: (options) ->
    @group_id = options.group_id
    @el = $('#groups-settings')
    @el.find('.remove-member').click (e) ->
      $.ajax
        url: "/memberships/#{$(e.currentTarget).attr('data-membership-id')}.json"
        type: "DELETE"
        data: 
          authenticity_token : $('meta[name=csrf-token]').attr('content')              
        success: (x) =>
          $(e.currentTarget).parents('tr').remove()
    $('body')
      .on 'focus', '[contenteditable]', ->
          $this = $(this)
          $this.data 'before', $this.html()
          return $this
      .on 'blur paste', '[contenteditable]', ->
          $this = $(this)
          if $this.data('before') isnt $this.html()
              $this.data 'before', $this.html()
              $this.trigger('change')
          return $this   
      .on 'keydown', '[contenteditable]', (e) ->
        $this = $(this)
        if(e.which == 13)
          $this.blur()
          $this.trigger('change')
          return false
        else
          return true
    @el.find('.group-editable').change (e) =>
      $.ajax
        url: "/groups/#{@group_id}.json"
        type: "PUT"
        data:
          authenticity_token : $('meta[name=csrf-token]').attr('content')    
          group:
            name : @el.find('.name').text()
            description: @el.find('.description').text()

    @el.find('.leave-group').click (e) =>
      if confirm("Knoda is even more fun with friends. Do you really want to leave this group?")
        $.ajax
          url: "/memberships/#{$(e.currentTarget).attr('data-membership-id')}.json"
          type: "DELETE"
          data: 
            authenticity_token : $('meta[name=csrf-token]').attr('content')              
          success: (x) =>
            window.location = "/groups"