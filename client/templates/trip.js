getTravel = function() {
    var results = Results.findOne({searchID:Session.get('searchID')}, {travel:1});
    if (results && results.hasOwnProperty('travel')) {
      return results.travel;
    } else {
      return [];
    }
}

getLodging = function() {
    var results = Results.findOne({'searchID':Session.get('searchID')}, {lodging:1});
    if (results && results.hasOwnProperty('lodging')) {
      return results.lodging;
    } else {
      return [];
    }
}

getEvent = function() {
    var results = Results.findOne({'searchID':Session.get('searchID')}, {source:1, events:1});
    if (results && results.hasOwnProperty('events')) {
      return results.events;
    } else {
      return [];
    }
}

Template.trip.onRendered(function(){
  this.$('ul.tabs').tabs();

  this.$('img.lazy').unveil();

  // Watch for new playlists
  //var modalPlaylists = 

  /*this.autorun( function() {
    var $container = $('.masonry-grid');
    $container.masonry({
      columnWidth: '.col',
      itemSelector: '.col'
    });
  });*/
});

Template.travelResult.onRendered(function(){
  this.$('select').material_select();
});

Template.lodgingResult.onRendered(function(){
  this.$('select').material_select();
  this.$('img.lazy').unveil(600);
  $(window).trigger("lookup");
});

Template.eventResult.onRendered(function(){
  this.$('select').material_select();
  this.$('img.lazy').unveil(600);
  $(window).trigger("lookup");
});

Template.trip.helpers({
  playlists: function() {
    console.log('getting playlists');
    lists = Playlists.find({ownerId: Meteor.userId()}).fetch();
    return lists;
  },

  isProfile: function() {
    return false;
  },

  destination: function() {
    return Session.get('destination');
  },

  eventResults: function() {
    return getEvent();
  },

  lodgingResults: function() {
    return getLodging();
  },

  travelResults: function() {
    return getTravel();
  },

  hasTravelResults: function() {
    return (getTravel().length > 0)
  },

  hasEventResults: function() {
    return (getEvent().length > 0)
  },

  hasLodgingResults: function() {
    return (getLodging().length > 0)
  }

});

Template.trip.events({
  'change .playlistOption': function(e) {
    var tar = $(e.target);
    var newList = tar.parents('.input-field').siblings('.input-field.new-playlist');
    if (tar.val() == 'new') {
      if (newList.hasClass('hidden')) {
        newList.removeClass('hidden');
      } 
    } else if (!newList.hasClass('hidden')) {
      newList.addClass('hidden');
    }
  },
  
  'click .save-to-trip.modal-trigger': function(e) {
    e.preventDefault();
    if (!Meteor.user()) {
      alert('Cannot save to trip unless you sign in.');
    } else {
      $( $(e.target).attr('href') ).openModal();
    }
    return false;
  },

  'click .save-result': function(e) {
    console.log('save result clicked');
    e.preventDefault();
    if ( !Meteor.user() ) {
      alert('Cannot add to playlist unless you sign in');
    } else {
      console.log('logged in');

      // Find Playlist
      tar = $(e.target);
      var selectedPlaylist = tar.parents('.modal').find('select.playlistOption');
      var playlist = {};

      if (selectedPlaylist.val() == 'new') {
        console.log('new playlist');
        newPlaylistName = selectedPlaylist.parents('form').find('.input-field.new-playlist .name').val();
        Meteor.call('createPlaylist', Meteor.userId(), newPlaylistName, tar);
        playlist = Playlists.findOne({
          'ownerId':Meteor.userId(),
          'name':newPlaylistName 
        }); 

        // Add new playlist to options
        /*selects = $('select.playlistOption');
        for (var i=0; i<selects.length; ++i) {
          $(selects[i]).append("<option value="+playlist._id+">"+newPlaylistName+"</option>");
          console.log(selects[i]);
        }*/

      } else {
        playlist = Playlists.findOne({
          'ownerId':Meteor.userId(),
          '_id': selectedPlaylist.val()
        });
      }

      // Save result
      var save = true;
      if (tar.parents('.modal').hasClass('event')) {
      for (var i=0; i<playlist.events.length; i++) {
        if (playlist.events[i]['id'] == this.id) {
          save = false;
          break;
        }
      }
      if (save) {
        Meteor.call('addEventToPlaylist', playlist._id, this);
      }
      } else if (tar.parents('.modal').hasClass('lodging')) {
      for (var i=0; i<playlist.lodging.length; i++) {
        if (playlist.lodging[i]['id'] == this.id) {
          save = false;
          break;
        }
      }
      if (save) {
        Meteor.call('addLodgingToPlaylist', playlist._id, this);
      }
      } else if (tar.parents('.modal').hasClass('travel')) {
      for (var i=0; i<playlist.travel.length; i++) {
        if (playlist.travel[i]['id'] == this.id) {
          save = false;
          break;
        }
      }
      if (save) {
        Meteor.call('addTravelToPlaylist', playlist._id, this);
      }
      }
    }
  }
});
