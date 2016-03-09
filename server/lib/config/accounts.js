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
	            appId: "1739964919568660",
	            secret: "858ba8a12c52a2394f8febd89600a3cc"
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
          clientId: "133641749446-ipp0bfpfj09d89vquf8ukkgeka9nuamf.apps.googleusercontent.com",
          client_email: "kalkanirb@gmail.com",
          secret: "IYunYNP-de2XPzNvREwUp-tZ"
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
