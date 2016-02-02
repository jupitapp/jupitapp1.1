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

  departureTime: ()->
    return moment(this.slice[0].segment[0].leg[0].departureTime).format('hh:mm a')

  arrivalTime: ()->
    return moment(this.slice[0].segment[0].leg[0].arrivalTime).format('hh:mm a')

  flightTime: ()->
    return Math.floor(this.slice[0].duration / 60) + "h" + (this.slice[0].duration % 60) + "m"

  flightNumber: ()->
    return "Flight " + this.slice[0].segment[0].flight.number

  airlines: ()->
    return "http://www.gstatic.com/flights/airline_logos/70px/" + this.slice[0].segment[0].flight.carrier + ".png"

  hasPhotos: ()->
    return false; #(this.photos.length > 0)

  getPhoto: ()->
    return this.photos[0].large

  sale: ()->
    return this.saleTotal.slice(0,3) + " " + this.saleTotal.slice(3)
)
