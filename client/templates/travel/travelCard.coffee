Template.travelCard.events(
  'click .remove-event': (e)->
    e.preventDefault()
    playlist = Playlists.findOne({'ownerId':Meteor.userId()})
    if (!playlist)
      alert('Something went wrong. Cannot remove item.')
    else
      Meteor.call('removeFromPlaylist', playlist._id, this, 'travel')
)

Template.travelCard.helpers(
  isProfile: ()->
    return ($('.card').closest('.profile').length > 0)

  orig: ()->
    return this.pricing[0].fare[0].origin

  dest: ()->
    return this.pricing[0].fare[0].destination

  hasPhotos: ()->
    return false; #(this.photos.length > 0)

  getPhoto: ()->
    return this.photos[0].large
)
