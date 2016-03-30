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
              // appId: "1739964919568660", // local
	            appId: Meteor.settings.private.FACEBOOK_APP_ID,
              // secret: "858ba8a12c52a2394f8febd89600a3cc" // local
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
          // clientId: "133641749446-ipp0bfpfj09d89vquf8ukkgeka9nuamf.apps.googleusercontent.com", // local
          clientId: Meteor.settings.private.GOOGLE_LOGIN_CLIENT_ID,
          // client_email: "kalkanirb@gmail.com", //local
          client_email: Meteor.settings.private.GOOGLE_LOGIN_EMAIL,
          // secret: "IYunYNP-de2XPzNvREwUp-tZ" // local
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
