self= @
Meteor.subscribe "pages"

Meteor.Router.add
  '': 'main'
  '/pages': ->
    Session.set 'n', 0
    'pages'
  '/pages/:n':(n)->
    Session.set 'n', n
    'pages'
  '/src/:name': (name)->
    if Meteor.userId() and name
      Session.set 'page', name
      'src'
  '/ed/:id': (id)->
    Session.set 'id', id
    'edit'
  '/edit/:name': (name)->
    Session.set 'page', name
    page = self.pages.findOne name:name
    if page
      Session.set 'id', page._id
      # console.log page._id
    'edit'
  '/:name': (name)->
    Session.set 'page', name
    'view'

  Template.body.helpers
    layoutName:()->
      if Meteor.Router.page()
        Meteor.Router.page()
      else
        '404'