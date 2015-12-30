Template.loading.onRendered () ->
  if ( ! Session.get('loadingSplash') )
    this.loading = window.pleaseWait(
      logo: '/branding/jupitlogo.png'
      backgroundColor: '#7f8c8d'
      loadingHtml: message + spinner
    )
    Session.set('loadingSplash', true) # just show loading splash once

Template.loading.destroyed = () ->
  if ( this.loading )
    this.loading.finish()
  


message = '<p class="loading-message">Your page is loading</p>'
spinner = '<div class="sk-spinner sk-spinner-rotating-plane"></div>'
