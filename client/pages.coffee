self = @
Meteor.subscribe "pages"
Template.pages.list = ->
  self.pages.find()