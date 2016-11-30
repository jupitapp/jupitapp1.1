Template.restaurantCard.helpers(
  hasPhotos: ()->
    # return (this.photos != undefined)
    return true

  getPhoto: ()->
    if this.photos == undefined
      return this.icon
    else
      return  "https://maps.googleapis.com/maps/api/place/photo?key=" + Meteor.settings.public.GOOGLE_MAPS_API + "&maxwidth=288&photoreference=" + this.photos[0].photo_reference;

  getLink: ()->
    if this.photos != undefined && this.photos[0].html_attributions != undefined
      return $($.parseHTML(this.photos[0].html_attributions[0])).attr("href");
    else
      return null;

  getBackgroud: ()->
    return "bg.png"
)
