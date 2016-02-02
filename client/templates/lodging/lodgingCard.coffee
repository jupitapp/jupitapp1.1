Template.lodgingCard.helpers(
  hasPhotos: ()->
    return (this.photos.length > 0)

  getPhoto: ()->
    return this.photos[0].large

  getBackgroud: ()->
    return "bg.png"
)
