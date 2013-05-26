self = @

marked.setOptions
  gfm: true
  tables: true
  breaks: false
  pedantic: false
  sanitize: true
  smartLists: true
  langPrefix: "language-"
  highlight: (code, lang) ->
    return highlighter.javascript(code)  if lang is "js"
    code

Meteor.subscribe "pages"

reJack = /#{{[a-zA-Z0-9\.\-\+\_\*]*}}/gim

findJack = (content)->
  search = content.match reJack
  if search
    for name in search
      replaceText = getPage name.replace('#{{','').replace('}}','')
      content = content.replace name, replaceText
  content

getPage = (name)->
  page = self.pages.findOne name:name
  if page
    Jacks = findJack page.content
  else
    if Meteor.userId()
      ' [ **'+name+'**](/edit/'+name+') Сделаем?'
    else
      ''
Template.view.name = ()->
  Session.get 'page'

Template.view.owned = ()->
  name = Session.get 'page'
  page = self.pages.findOne name:name
  if page?.owner is Meteor.userId()
    owned = name


Template.main.content = ()->
  resp = getPage 'main'
  "<div class=\"md\">" + marked( resp) + "</div>"

Template.md.content = ()->
  name = Session.get 'page'
  getPage name

Template.view.content = ()->
  name = Session.get 'page'
  resp = getPage name
  "<div class=\"md\">" + marked( resp) + "</div>"

Template.edit.page = ()->
  name = Session.get 'page'
  self.pages.findOne name:name

Template.edit.events
  'click a#save':(e)->
    name = Session.get 'page'
    update =
      displayName: $('input#displayName').val()
      content:$('textarea#content').val()
    id = self.pages.findOne( name:name)._id
    self.pages.update id, $set:update
    # console.log update