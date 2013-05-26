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
        else
          document.title = page.displayName
      Session.set 'page', name
      'edit'
    else
      '404'
  '/md/:name': (name)->
    Session.set 'page', name
    page = self.pages.findOne name:name
    if page
      document.title = page.displayName
    'md'
  '/:name': (name)->
    page = self.pages.findOne name:name
    if page
      document.title = page.displayName
    Session.set 'page', name
    'view'

  Template.body.helpers
    layoutName:()->
      if Meteor.Router.page()
        Meteor.Router.page()
      else
        '404'