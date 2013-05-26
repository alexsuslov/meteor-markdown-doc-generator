Meteor.subscribe "pages"

Meteor.Router.add
  '': 'main'
  '/edit/:name': (name)->
    if Meteor.userId()
      if name
        page = self.pages.findOne name:name
        unless page
          page =
            name:name
            owner:Meteor.userId()
          self.pages.insert page
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