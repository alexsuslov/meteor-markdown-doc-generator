reJack = /#{{[a-zA-Z0-9\.\-\+\_\*]*}}/gim

Template.subPages.pages = ()->
  # console.log 'subPages'
  pages = []
  page = self.pages.findOne Session.get 'id'
  if page
    search = page.content.match reJack
    if search
      for name in search
        pageName = name.replace('#{{','').replace('}}','')
        pages.push pageName
  pages