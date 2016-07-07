Template.index.onRendered(function() {
  // return $('.button-collapse').sideNav();
  	// $('body').addClass('x-bootstrap');
});

Template.index.helpers({
  // profileUrl: function() {
  //   return '/profile/' + Meteor.user().username;
  // },
  // currentUser: function() {
  //   return Meteor.user();
  // }
});

Template.index.events({
	'submit #text-me' (event) {
		event.preventDefault();

		console.log("Submit");

		const target = event.target;
		const text = target.mobile.value;

		Mobiles.insert({
			text,
			createdAt: new Date(),
		});

		Meteor.call('sendEmail', {
			to: 'jupit@jupit.co',
			from: 'inquiry@jupit.co',
			subject: text + " user registered on jupit.co",
			text: text + " user registered on jupit.co",
			html: null
		});

		target.mobile.value = '';
	}
});