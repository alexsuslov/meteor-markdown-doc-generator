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
    self.pages.find({},sort:displayName:1)

  # default settings
  pages = [
    {
      name:'test'
      displayName:'test'
      content:'test'
      owner:0
    }
    {
      name:'test1'
      displayName:'test1'
      content:'test1 #{{test}}'
      owner:0
    }
  ]
  i = pages.length + 1
  while i -= 1
    page =  pages[i-1]
    self.pages.insert page unless self.pages.findOne displayName:page.displayName