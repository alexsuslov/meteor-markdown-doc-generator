self = @

Meteor.subscribe "pages"
Meteor.subscribe "archPages"

###
#
# Edit
#
###

Template.edit.button = ()->
  Session.get 'button'

Template.edit.path = ()->
  Session.get 'page'

Template.edit.page = ()->
  page = self.pages.findOne Session.get 'id'

  unless page
    Session.set 'button', true
  else if page?.owner is Meteor.userId()
    Session.set 'button', true
  else
    Session.set 'button', false
  page

###
#
# Edit.events
#
###

Template.edit.events
  'click a#delete':(e)->
    id = Session.get 'id'
    if id
      self.pages.remove id

  'click a.save':(e)->
    id = Session.get 'id'
    name = Session.get 'page'
    update =
      displayName: $('input#displayName').val()
      tags: $('input#tags').val()
      content:$('textarea#content').val()
      values:$('textarea#values').val()
      update: new Date()
    self.pages.archPages update
    if id
      # console.log update
      self.pages.update id, $set:update
    else
      # console.log 'insert'
      update.owner = Meteor.userId()
      update.name = name
      Session.set 'id', self.pages.insert update

