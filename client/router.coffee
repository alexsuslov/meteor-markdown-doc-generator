self= @
Meteor.subscribe "pages"

isUser = (usersPage, anonPage)->
  anonPage = 'main' unless anonPage

  if Meteor.userId
    usersPage
  else
    anonPage


Meteor.Router.add
  '': 'main'
  '/sigin':'auth'

  '/arhive': ->
    Session.set 'n', 0
    isUser 'arhive'

  '/arhive/:n':(n)->
    Session.set 'n', n
    isUser 'arhive'

  '/pages': ->
    Session.set 'n', 0
    isUser 'pages'

  '/pages/:n':(n)->
    Session.set 'n', n
    isUser 'pages'

# Source view

  '/src/:name': (name)->
    Session.set 'page', name
    isUser 'src'

# Edit
#  by id
  '/ed/:id': (id)->
    Session.set 'id', id
    page = self.pages.findOne id
    Session.set 'page', page.name if page
    isUser 'edit'

#  by name
  '/edit/:name': (name)->
    Session.set 'page', name
    page = self.pages.findOne name:name
    Session.set 'id', page._id if page

    isUser 'edit', 'view'

# Normal view

  '/:name': (name)->
    Session.set 'page', name
    'view'

  Template.body.helpers
    layoutName:()->
      console.log Meteor.Router.page()
      if Meteor.Router.page()
        Meteor.Router.page()
      else
        '404'