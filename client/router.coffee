self= @
Meteor.subscribe "pages"

Meteor.Router.add
  '': 'main'

  '/arhive': ->
    Session.set 'n', 0
    'arhive'

  '/arhive/:n':(n)->
    Session.set 'n', n
    'arhive'

  '/pages': ->
    Session.set 'n', 0
    'pages'

  '/pages/:n':(n)->
    Session.set 'n', n
    'pages'

# Source view

  '/src/:name': (name)->
    if Meteor.userId() and name
      Session.set 'page', name
      'src'

# Edit
#  by id
  '/ed/:id': (id)->
    Session.set 'id', id
    page = self.pages.findOne id
    Session.set 'page', page.name if page
    'edit'

#  by name
  '/edit/:name': (name)->
    Session.set 'page', name
    page = self.pages.findOne name:name
    Session.set 'id', page._id if page

    if Meteor.userId()
      'edit'
    else
      'view'

# Normal view

  '/:name': (name)->
    Session.set 'page', name
    'view'

  Template.body.helpers
    layoutName:()->
      if Meteor.Router.page()
        Meteor.Router.page()
      else
        '404'