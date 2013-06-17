self = @
Meteor.subscribe "pages"

###
#
# Pages.helpers
#
###

Template.pages.filter = ()->
  Session.get 'filter'

Template.pages.list = ->
  n = Session.get 'n'
  unless n
    n = 0
  # filter
  filter = {}
  if Session.get 'filter'
    re = new RegExp (Session.get 'filter'),'gi'
    filter =
      $or:[
        {name: re}
        {tags: re}
      ]
  # paggination
  options =
    limit:20
    skip:n * 20

  pages = self.pages.find(filter)
  Session.set 'pages', pages.count()

  self.pages.find(filter,options)

###
#
# Pages.helpers
#
###

Template.pages.helpers
  user:(id)->
    Meteor.subscribe "userName"
    user = Meteor.users.findOne id
    user.profile.name if user?.profile?.name

###
#
# Pages.events
#
###

Template.pages.events

  'keyup input#filter':(e)->
    e.preventDefault()
    Session.set 'filter', $('input#filter').val() if e.keyCode is 13

  'click a.edit':(e)->
    Session.set 'id', @_id


