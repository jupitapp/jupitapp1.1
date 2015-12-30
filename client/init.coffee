Meteor.startup( () ->

  GoogleMaps.load(
    key: Meteor.settings.public.GOOGLE_MAPS_API
    libraries: 'places'
  )
)
