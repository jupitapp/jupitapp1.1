Template.landingBody.onRendered( () ->
  $('.button-collapse').sideNav()
)

Template.landingBody.helpers(
  profileUrl: () ->
    return '/profile/'+Meteor.user().username
  currentUser: () ->
    return Meteor.user()
)
