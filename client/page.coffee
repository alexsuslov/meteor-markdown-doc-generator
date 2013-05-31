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
reJackValues = /#{[a-zA-Z0-9\.\-\+\_\*]*}/gim

findJack = (content, restrict)->
  search = content.match reJack
  if search
    for name in search
      pageName = name.replace('#{{','').replace('}}','')
      # clean from dead cicle
      unless restrict.indexOf pageName is -1
        replaceText = ' [ **'+pageName+'**](/edit/'+pageName+')'
      else
        replaceText = renderPage  pageName, restrict
      content = content.replace name, replaceText
  search = content.match reJackValues
  if search
    for name in search
      valueName = name.replace('#{','').replace('}','')
      if window.pageData?[valueName]
        content = content.replace name, window.pageData[valueName]

  marked content

renderPage = (name,restrict)->
  page = self.pages.findOne name:name

  if page
    unless restrict
      if page.values
        try
          window.pageData =  JSON.parse page.values
        catch e
          console.log e
      document.title = page.displayName
      restrict= [name]
    else
      restrict.push name

    Jacks = findJack page.content, restrict
  else
    ''
  # else
  #   if Meteor.userId()
  #     # Template.createNew name
  #     # ' <a href="/edit/'+name+'""> '+name+'</a>'
  #   else
  #     # ''
###
view
###

Template.view.content = ()->
  content = renderPage Session.get 'page'
  if content
    marked content

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
  renderPage 'main'

###
src
###
Template.src.content = ()->
  page = self.pages.findOne( name:Session.get 'page')
  if page
    page.content
###
edit
###

Template.edit.path = ()->
  Session.get 'page'

Template.edit.page = ()->
  self.pages.findOne Session.get 'id'

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
    if id
      # console.log update
      self.pages.update id, $set:update
    else
      # console.log 'insert'
      update.owner = Meteor.userId()
      update.name = name
      self.pages.insert update
