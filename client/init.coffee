Meteor.startup( () ->

  GoogleMaps.load(
    key: Meteor.settings.public.GOOGLE_MAPS_API
    libraries: 'places'
  )

  Meteor.absoluteUrl.defaultOptions.rootUrl = 'http://jupit.co/'
)
