# Vars
dateStartFormat = "D MMMM, YYYY"

# Get IATA Airport code for city
getAirportCode = (filters, params, callback)->
    console.log "Getting airport codes..."
    iata_url="https://airport.api.aero/airport/nearest/#{filters.city.lat}/#{filters.city.lng}?user_key=9740853f634f8ca3da48d217674d7171"
    Meteor.http.call('GET', iata_url, (err, results) ->
      if err
        throw err
      else
        console.log('Got destination city airport..')
        resContent = JSON.parse(results.content[9..results.content.length-2])
        console.log resContent
        params.request.slice[0].destination = resContent.airports[0].code
  
        iata_url="https://airport.api.aero/airport/nearest/#{filters.from_city.lat}/#{filters.from_city.lng}?user_key=9740853f634f8ca3da48d217674d7171"
        Meteor.http.call('GET', iata_url, (err, results) ->
          if err
            throw err
          else
            console.log('Got origin city airport')
            resContent = JSON.parse(results.content[9..results.content.length-2])
            console.log resContent
            params.request.slice[0].origin = resContent.airports[0].code
            callback(filters, params)
        )
    )

Meteor.methods(

  googleQPX: (searchID, filters) ->
    apiurl = "https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyBilXpNsv4rUBFUq0HjQB4pkuqCX26yzRk"##{Meteor.settings.private.GOOGLE_QPX_API}"
    headers =
      Accept: 'application/json'
    # Set google QPX params
    params =
      request:
        passengers:
          adultCount: 1
        slice: [
          origin: undefined
          destination: undefined
          date: moment(filters.dateStart, dateStartFormat).format("YYYY-MM-DD")
        ]
        solutions: 51

    if Meteor.isServer
      getAirportCode(filters, params, (filters, params)->
        Meteor.http.call('POST', apiurl,
                data:params
                headers:headers
               ,
                (err, results) ->
                  if err
                    throw err
                  else if results.data.trips.tripOption is null
                    console.log("null trips")
                  else
                    console.log('Got Google QPX results')
                    console.log results
                    Meteor.call('insertResult', searchID, travel: results.data.trips.tripOption, filters)
                    # This throws a tripOption error when data isn't returned
            )
      )

  zilyo: (searchID, filters) ->
    apiurl = 'https://zilyo.p.mashape.com/search'
    headers =
      'X-Mashape-Key': '7F4mp8MSrEmsh3wY8dvDegO7V9IWp1Qzz39jsnV603TK9EJny1'
      Accept: 'application/json'
    params = {}

    params.latitude = filters.city.lat
    params.longitude = filters.city.lng

    Meteor.http.call('GET', apiurl,
      params:params
      headers:headers
     ,
      (error, results) ->
        console.log('Got zilyo results')
        Meteor.call('insertResult', searchID, lodging: JSON.parse(results.content).result, filters)
    )


  seatGeek: (searchID, filters) ->
    apiurl = 'http://api.seatgeek.com/2/events/'
    params =
      per_page: 10
      sort: 'score.desc'
    ###
    if (filters.budget.max)
      params['highest_price.lte'] = filters.budget.max

    if (filters.budget.min)
      params['lowest_price.gte'] = filters.budget.min
    ###
    
    params.lat = filters.city.lat
    params.lon = filters.city.lng
    if filters.dateStart isnt undefined
      params['datetime_utc.gte'] = moment(filters.dateStart, "D MMMM, YYYY").format("YYYY-MM-DD")
    
    Meteor.http.call('GET', apiurl,
      params:params
     ,
      (error, results) ->
        console.log('Got seatgeek results')
        seatgeek = results
        for event in results.data.events
          event['source'] = {}
          event['source']['api'] = 'seatgeek'
        Meteor.call('insertResult', searchID, events:results.data.events, filters)
    )


  eventBrite: (searchID, filters) ->
    apiurl = 'https://www.eventbriteapi.com/v3/events/search/'
    token = 'BFK432G7D4H3FACVOLBI'
    params = {'token':token}
    #params.price = filters.freeOnly ? 'free' : 'paid'
    params['location.latitude'] = filters.city.lat
    params['location.longitude'] = filters.city.lng
    if filters.dateStart isnt undefined
      params['start_date.range_start'] = moment(filters.dateStart, dateStartFormat).format("YYYY-MM-DDThh:mm:ss")
    params.sort_by = 'date'

    Meteor.http.call('GET', apiurl, {params: params},
      (error, results) ->
        console.log('Got eventbrite results')
        if error
          console.log error
          console.log params
        else
          for event in results.data.events
            event['source'] = {}
            event['source']['api'] = 'eventbrite'
          Meteor.call('insertResult', searchID, events:results.data.events, filters)
    )


  insertResult: (searchID, results, filters) ->
    if ( !Results.findOne({searchID:searchID}) )
      Results.insert(
        searchID: searchID
        created: new Date()
        filters: filters
        events: []
        lodging: []
        travel: []
      )
    if (results.hasOwnProperty('events'))
      Results.update({searchID:searchID}, {$addToSet: {events: {$each:results.events}}})
    if (results.hasOwnProperty('lodging'))
      Results.update({searchID:searchID}, {$addToSet: {lodging: {$each:results.lodging}}})
    if (results.hasOwnProperty('travel'))
      Results.update({searchID:searchID}, {$addToSet: {travel: {$each:results.travel}}})


  createPlaylist: (ownerId, name, tar) ->
    if ( !Playlists.findOne({ownerId:ownerId, name:name}) )
      playlist = Playlists.insert(
        name: name
        ownerId: ownerId
        events: []
        travel: []
        lodging: []
      )

  removeFromPlaylist: (playlist_id, result, type) ->
    playlistItem = {}
    playlistItem[type] = {}
    playlistItem[type].id = result.id
    Playlists.update( {_id:playlist_id},
      $pull: playlistItem
    )

  addTravelToPlaylist: (playlist_id, result) ->
    Playlists.update({_id:playlist_id}, {$push:{travel:result}})

  addLodgingToPlaylist: (playlist_id, result) ->
    Playlists.update({_id:playlist_id}, {$push:{lodging:result}})


  addEventToPlaylist: (playlist_id, result) ->
    Playlists.update({_id:playlist_id}, {$push:{events:result}})


  emptyPlaylists: () ->
    Playlists.remove({})


  emptyResults: () ->
    Results.remove({})

)
