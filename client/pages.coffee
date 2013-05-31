self = @
Meteor.subscribe "pages"

Template.pages.list = ->
  filter = {}
  if Session.get 'filter'
    re = new RegExp (Session.get 'filter'),'gi'
    filter =
      $or:[
        {name: re}
        {tags: re}
      ]
  limit = limit:20
  self.pages.find(filter,limit)

Template.pages.filter = ()->
  Session.get 'filter'

Template.pages.helpers
  user:(id)->
    Meteor.subscribe "userName"
    user = Meteor.users.findOne id
    user.profile.name if user?.profile?.name

Template.pages.events
  'keyup input#filter':(e)->
    e.preventDefault()
    Session.set 'filter', $('input#filter').val() if e.keyCode is 13

  'click a.edit':(e)->
    Session.set 'id', @_id
