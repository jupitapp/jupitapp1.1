Template.plan.onRendered( () ->
  $('.datepicker').pickadate(
    selectMonths: true,
    selectYears: 15
  )

  $('#divpopup').show()
  $('#popup').show()
  $('#popup').click ->
    $('#divpopup').slideToggle()
    return

  window.filters = {}

  $.getJSON 'http://blog.jupit.co/wp-json/wp/v2/posts?per_page=3&_embed', (response) ->
    data = response[0]
    $('.blog-tile.one a').attr 'href', data.link
    $('.blog-tile.one a img').attr 'src', data._embedded['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url']
    $('.blog-tile.one p').html data.title.rendered
    data = response[1]
    $('.blog-tile.two a').attr 'href', data.link
    $('.blog-tile.two a img').attr 'src', data._embedded['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url']
    $('.blog-tile.two p').html data.title.rendered
    data = response[2]
    $('.blog-tile.three a').attr 'href', data.link
    $('.blog-tile.three a img').attr 'src', data._embedded['wp:featuredmedia'][0]['media_details']['sizes']['medium']['source_url']
    $('.blog-tile.three p').html data.title.rendered
    return

  this.autorun( () ->
   if GoogleMaps.loaded()
    $('input#city').geocomplete()
      .bind("geocode:result", (event, result) ->
        window.filters.city = result
        window.filters.city.lat = result.geometry.location.lat()
        window.filters.city.lng = result.geometry.location.lng()
      )
    $('input#fromCity').geocomplete()
      .bind("geocode:result", (event, result) ->
        window.filters.from_city = result
        window.filters.from_city.lat = result.geometry.location.lat()
        window.filters.from_city.lng = result.geometry.location.lng()
      )
  )
)

Template.plan.helpers(
  geoip: () -> return (Geolocation.currentLocation() isnt null)
  geocheck: () -> return (document.getElementByName('geoip').attribute('checked') is 'checked')
)

prepFilters = (e, callback) ->
  if window.filters.dateCheck
    window.filters.dateStart = $('#dateStart').val()
  callback(window.filters)

Template.plan.events(
  'click #flightCheck': (e) ->
    window.filters.flightCheck = flightCheck = e.target.checked
    if flightCheck
      if $('#fromLocation').hasClass('hidden')
        $('#fromLocation').removeClass('hidden')
      if $('#datePicker').hasClass('hidden')
        $('#dateCheck').click()
      $('#dateCheck').attr('disabled', '')

    else
      if !$('#fromLocation').hasClass('hidden')
        $('#fromLocation').addClass('hidden')
      if $('#dateCheck').attr('disabled') isnt undefined
        $('#dateCheck').removeAttr('disabled')

  'click #dateCheck': (e) ->
    window.filters.dateCheck = dateCheck = e.target.checked
    if dateCheck and $('#datePicker').hasClass('hidden')
      $('#datePicker').removeClass('hidden')
    else if !$('#datePicker').hasClass('hidden')
      if $('#flightCheck:checked').length is 0
        $('#datePicker').addClass('hidden')
      else
        $('#dateCheck').click()

  'submit form': (e) ->
    e.preventDefault()
    prepFilters(e, (filters) ->
      searchID = Random.id()
      Session.set('destination', filters.city.formatted_address)
      Session.set('searchID', searchID)
      if filters.flightCheck and filters.from_city isnt undefined and filters.dateCheck and filters.dateStart isnt undefined
        console.log 'Calling airfare API...'
        Meteor.call('googleQPX', searchID, filters)
      Meteor.call('googlePlaceLodging', searchID, filters)
      Meteor.call('eventBrite', searchID, filters)
      Meteor.call('seatGeek', searchID, filters)
      # Meteor.call('zilyo', searchID, filters)
      Meteor.call('googlePlaceRestaurants', searchID, filters)
      Router.go('trip')
      return false
    )
)
