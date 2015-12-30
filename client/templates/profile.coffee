###
Template.profile.events({
  'click .remove-event': (e) ->
    e.preventDefault()
    playlist = Playlists.findOne({'ownerId':Meteor.userId()})
    if (!playlist)
      alert('Something went wrong. Cannot remove item.')
    else
      Meteor.call('removeFromPlaylist', playlist._id, this)
})
###

Template.profile.helpers(
  isProfile: () ->
    return true

  playlists: () ->
    lists = Playlists.find({ownerId: Meteor.userId()}).fetch()
    for list in lists
      list['order'] = lists.indexOf(list)
    return lists
)

Template.playlist.helpers(
  first: () ->
    return (this.order is 0)
)

Template.profile.onRendered( () ->
  this.$('.collapsible').collapsible(
    accordion : false #A setting that changes the collapsible behavior to expandable instead of the default accordion style
  )
)
