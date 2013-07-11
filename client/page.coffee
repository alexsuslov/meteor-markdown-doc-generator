self = @

Meteor.subscribe "pages"
Meteor.subscribe "archPages"

###
#
# Edit
#
###

Template.edit.button = ()->
  page = self.pages.findOne( Session.get 'id')
  button = page.owner is Meteor.userId() if page
  button = true unless page
  button

Template.edit.path = ()->
  Session.get 'page'

Template.edit.page = ()->
  self.pages.findOne Session.get 'id'


###
#
# Edit.events
#
###

Template.edit.events
  'click button#my':(e)->
    console.log e

  'click a#delete':(e)->
    id = Session.get 'id'
    self.pages.remove id if id

  'click a.save':(e)->
    id = Session.get 'id'
    name = Session.get 'page'
    update =
      displayName: $('input#displayName').val()
      tags: $('input#tags').val()
      content:$('textarea#content').val()
      values:$('textarea#values').val()
      update: new Date()
    self.archPages.insert
      name:name
      displayName:update.displayName
      tags:update.tags
      content:update.content
      values:update.values
      values:update.values
      update:update.update
      owner:Meteor.userId()
    if id
      # console.log update
      self.pages.update id, $set:update
    else
      # console.log 'insert'
      update.owner = Meteor.userId()
      update.name = name
      Session.set 'id', self.pages.insert update

