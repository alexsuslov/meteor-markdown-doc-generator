Template.pagination.pgn = ->
  pages = Session.get 'pages'
  limit = 20
  pgn = []
  i = 0
  while i < pages / limit
    pgn.push i
    i += 1
  pgn

