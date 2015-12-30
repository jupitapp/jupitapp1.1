Template.eventCard.helpers(

  hasPhotos: ()->
    hasPhotos = false

    if this.source.api is 'seatgeek'
      if this.performers.length > 0
        if this.performers[0].image.length > 0
          hasPhotos = true

    else if this.source.api == 'eventbrite'
      if this.logo
        hasPhotos = true

    return hasPhotos

  getPhoto: ()->
    img = ''
    if this.source.api == 'seatgeek'
      img = this.performers[0].image
    else if this.source.api == 'eventbrite'
      img = this.logo.url
    return img

  getTitle: ()->
    title = ''
    
    if this.source.api == 'seatgeek'
      title = this.title
     else if this.source.api == 'eventbrite'
      title = this.name.text
    
    return title

  getUrl: ()->
    url = ''
    if this.source.api == 'seatgeek'
      url = this.url
    else if this.source.api == 'eventbrite'
      if this.vanity_url isnt undefined
        url = this.vanity_url
      else url = this.url
    return url
)
