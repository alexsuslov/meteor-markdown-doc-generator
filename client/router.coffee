Meteor.subscribe "pages"

Meteor.Router.add
  '': 'main'
  '/auth': 'auth'
  '/src/:name': (name)->
    if Meteor.userId() and name
      Session.set 'page', name
      'src'
  '/edit/:name': (name)->
    if Meteor.userId() and name
      Session.set 'page', name
      'edit'
    else
      'src'
  '/:name': (name)->
    Session.set 'page', name
    'view'

  Template.body.helpers
    layoutName:()->
      if Meteor.Router.page()
        Meteor.Router.page()
      else
        '404'