Template.appBody.onRendered( () ->
  $('.button-collapse').sideNav()
)

Template.appBody.helpers(
  profileUrl: () ->
    return '/profile/'+Meteor.user().username
  currentUser: () ->
    return Meteor.user()
)
