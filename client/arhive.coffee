self = @
Meteor.subscribe "archPages"

###
#
# Arhive
#
###

Template.arhive.content = ()->
  archPage = self.archPages.findOne Session.get 'archView'
  self.renderContent(archPage.name, archPage.content) if archPage

Template.arhive.filter = ()->
  Session.get 'filter'

Template.arhive.list = ->
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

  pages = self.archPages.find(filter)
  Session.set 'pages', pages.count()

  self.archPages.find(filter,options)

###
#
# Arhive.helpers
#
###

Template.arhive.helpers
  user:(id)->
    Meteor.subscribe "userName"
    user = Meteor.users.findOne id
    user.profile.name if user?.profile?.name

###
#
# Arhive.events
#
###

Template.arhive.events

  'keyup input#filter':(e)->
    e.preventDefault()
    Session.set 'filter', $('input#filter').val() if e.keyCode is 13

  'click a.view':(e)->
    Session.set 'archView', @_id

  'click button.restore':(e)->
    console.log e
    # Session.set 'id', @_id


