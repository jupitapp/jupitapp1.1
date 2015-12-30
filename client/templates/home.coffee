Template.home.onRendered( () ->
  $('.parallax').parallax()
)

Template.home.events(
  'click .next': (e) ->
    e.preventDefault()
    Router.go('plan')
    return
)
