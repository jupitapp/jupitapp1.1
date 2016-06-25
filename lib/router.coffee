Router.configure(
  loadingTemplate: 'loading'
  layoutTemplate: 'appBody'
  index: 'index'
  waitOn: () ->
    return [
    ]
  trackPageView: true
)

Router.route('/trip', ()->
  this.render('trip',
    data: ()->
      return Playlists.find({ownerId: Meteor.userId()})
  )
)


Router.map( () ->
  this.route('home',
    path: '/'
    onBeforeAction: () ->
      if !Meteor.user()
        this.layout('index')
      else
        this.redirect('plan')
      this.next()
  )
  this.route('plan')
  this.route('profile',
    path: '/profile/:username'
    data: () ->
      return Meteor.users.findOne({username:this.params.username})
  )
)

# Useraccounts
AccountsTemplates.configure(
  defaultLayout: 'atFormLayout'
  sendVerificationEmail: true
  defaultState: "signUp"
  enablePasswordChange: true
  showForgotPasswordLink: true
  showResendVerificationEmailLink: true
  enforceEmailVerification: true
  preSignUpHook: (pwd, info)->
    console.log 'pre signup hook...'
    Meteor.call('sendEmail',
        to: 'Jupit.co <jupitco@gmail.com>'
        from: 'Jupit Accts <postmaster@mptysquare.com>'
        subject: 'Another Signup!'
        text: "username: #{info.username}  email: #{info.email}"
        html: ''
      )
)

AccountsTemplates.configureRoute('signUp',
  name: 'sign-up'
)

# Include username field
pwd = AccountsTemplates.removeField('password')
AccountsTemplates.removeField('email')
AccountsTemplates.addFields([
  _id: "username"
  type: "text"
  displayName: "username"
  required: true
  minLength: 5
 ,
  _id: 'email'
  type: 'email'
  required: true
  displayName: "email"
  re: /.+@(.+){2,}\.(.+){2,}/
  errStr: 'Invalid email'
 ,
  pwd
])

AccountsTemplates.configureRoute('signIn',
  name: 'sign-in'
)
AccountsTemplates.configureRoute('enrollAccount')
AccountsTemplates.configureRoute('forgotPwd')
#AccountsTemplates.configureRoute('resetPwd')
#AccountsTemplates.configureRoute('changePwd')
AccountsTemplates.configureRoute('verifyEmail')

#Router.plugin('ensureSignedIn',
#  except: ['home', 'sign-up', 'sign-in']
#)
