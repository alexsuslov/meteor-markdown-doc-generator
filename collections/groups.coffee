self = @
###
group
  @displayName:String
  @users:[userID,]
  @owner:userID
###
@groups = new Meteor.Collection 'groups'

@groups.allow
  insert: (userId, doc)->
    true
  update:(userId, docs, fields, modifier)->
    true if docs.owner is userId
  remove:  (userId, docs)->
    true if docs.owner is userId


if Meteor.isServer
  Meteor.publish "groups", ->
    self.groups.find({},sort:displayName:1)

  Meteor.methods
  'userAdd':(userId,group)->
    # @todo add admin restrict
    group = self.groups.findOne displayName:group
    if group
      i = group.users.indexOf userId if group.users
      unless i is -1
        group.users.push userId
        self.groups.update group._is, $set:users:group.users


  'inGroup':(userId,group)->
    group = self.groups.findOne displayName:group
    i = group.users.indexOf userId if group.users
    unless i is -1
      userId
  # default settings
  groups = ['system','developer','admin']
  i = groups.length
  while i -= 1
    group =
      displayName: groups[i - 1]
      owner: 0
      users: []
    self.groups.insert group unless self.groups.findOne displayName:group.displayName