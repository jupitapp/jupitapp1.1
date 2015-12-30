Template.saveTripModal.helpers(
  playlists: ()->
    return Playlists.find {ownerId:Meteor.userId()}
)
