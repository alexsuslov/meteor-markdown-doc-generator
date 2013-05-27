self = @

marked.setOptions
  gfm: true
  tables: true
  breaks: false
  pedantic: false
  sanitize: false
  smartLists: true
  langPrefix: "language-"
  highlight: (code, lang) ->
    return highlighter.javascript(code)  if lang is "js"
    code

Meteor.subscribe "pages"

reJack = /#{{[a-zA-Z0-9\.\-\+\_\*]*}}/gim

findJack = (content, restrict)->
  search = content.match reJack
  if search
    for name in search
      pageName = name.replace('#{{','').replace('}}','')
      # if restrict < 5
      replaceText = getPage  pageName, restrict
      content = content.replace name, replaceText
  content

getPage = (name,restrict)->
  page = self.pages.findOne name:name

  if page
    unless restrict
      document.title = page.displayName
      restrict = 1
    Jacks = findJack page.content, restrict + 1
  else
    if Meteor.userId()
      ' [ **'+name+'**](/edit/'+name+') Сделаем?'
    else
      ''
###
view
###

Template.view.content = ()->
  name = Session.get 'page'
  resp = getPage name
  "<div class=\"md\">" + marked( resp) + "</div>"

Template.view.name = ()->
  Session.get 'page'

Template.view.owned = ()->
  name = Session.get 'page'
  page = self.pages.findOne name:name
  if page?.owner is Meteor.userId()
    owned = name
###
main
###

Template.main.content = ()->
  resp = getPage 'main'
  "<div class=\"md\">" + marked( resp) + "</div>"
###
md
###

Template.md.content = ()->
  name = Session.get 'page'
  getPage name

###
edit
###

Template.edit.path = ()->
  Session.get 'page'

Template.edit.page = ()->
  self.pages.findOne name:Session.get 'page'

Template.edit.events
  'click a#save':(e)->
    name = Session.get 'page'
    update =
      displayName: $('input#displayName').val()
      tags: $('input#tags').val()
      content:$('textarea#content').val()
    page = self.pages.findOne( name:name)
    if page
      self.pages.update page._id, $set:update
    else
      update.owner = Meteor.userId()
      update.name = name
      self.pages.insert update
