self = @
@archPages = new Meteor.Collection 'archPages'
@archPages.allow
  insert: (userId, doc)->
    true
  update:(userId, docs, fields, modifier)->
    false
  remove:  (userId, docs)->
    false

if Meteor.isServer
  Meteor.publish "archPages", ->
    self.archPages.find({})
