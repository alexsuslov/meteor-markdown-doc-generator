Meteor.subscribe "pages"

Meteor.Router.add
  '': 'main'
  '/auth': 'auth'
  '/edit/:name': (name)->
    if Meteor.userId() and name
      Session.set 'page', name
      'edit'
    else
      '404'
  '/:name': (name)->
    Session.set 'page', name
    'view'

  Template.body.helpers
    layoutName:()->
      if Meteor.Router.page()
        Meteor.Router.page()
      else
        '404'