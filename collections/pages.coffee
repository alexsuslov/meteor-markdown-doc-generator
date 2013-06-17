self = @

@pages = new Meteor.Collection 'pages'

@pages.allow
  insert: (userId, doc)->
    true
  update:(userId, docs, fields, modifier)->
    true if docs.owner is userId
  remove:  (userId, docs)->
    true if docs.owner is userId


if Meteor.isServer
  Meteor.publish "pages", ->
    self.pages.find({},sort:update:-1)
