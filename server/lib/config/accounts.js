/**
 * @Company: winrtech
 * @Author: rahul
 */
'use strict';

Meteor.startup(function() {
    // Add Facebook configuration entry
    ServiceConfiguration.configurations.update(
    	{
        	service: "facebook"
	    }, 
	    {
	        $set: {
	            appId: Meteor.settings.private.FACEBOOK_APP_ID,
	            secret: Meteor.settings.private.FACEBOOK_SECRET
	        }
	    }, 
	    {
        	upsert: true    
        }
    );

    // Add Google configuration entry
    ServiceConfiguration.configurations.update(
      { service: "google" },
      { $set: {
          clientId: Meteor.settings.private.GOOGLE_LOGIN_CLIENT_ID,
          client_email: Meteor.settings.private.GOOGLE_LOGIN_EMAIL,
          secret: Meteor.settings.private.GOOGLE_LOGIN_SECRET
        }
      },
      { upsert: true }
    );

    // ServiceConfiguration.configurations.update(
    //   { service: "twitter" },
    //   { $set: {
    //       consumerKey: "XXXXXXXXXXXX",
    //       secret: "XXXXXXXX"
    //     }
    //   },
    //   { upsert: true }
    // );

});
