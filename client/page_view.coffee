self = @
Meteor.subscribe "pages"

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




jackPages = (content, restrict)->
  reJack = /#{{[a-zA-Z0-9\.\-\+\_\*]*}}/gim
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
  content

jackValues = (content)->
  reJackValues = /#{[a-zA-Z0-9\.\-\+\_\*]*}/gim
  search = content.match reJackValues
  if search
    for name in search
      valueName = name.replace('#{','').replace('}','')
      if window.pageData?[valueName]
        content = content.replace name, window.pageData[valueName]
  content

findJack = (content, restrict)->
  content = jackPages content, restrict
  content = jackValues content
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

self.renderContent = (name, content)->
  if name and content
    restrict = [name]
    findJack(content, restrict)

###
#
# view
#
###

Template.view.content = ()->
  renderPage Session.get 'page'

Template.view.name = ()->
  Session.get 'page'

Template.view.owned = ()->
  name = Session.get 'page'
  page = self.pages.findOne name:name
  if page?.owner is Meteor.userId()
    owned = name
###
#
# Main
#
###

Template.main.content = ()->
  renderPage 'main'

###
#
# Src
#
###

Template.src.content = ()->
  page = self.pages.findOne( name:Session.get 'page')
  page.content if page
