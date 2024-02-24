using Toybox.Background;
using Toybox.System as System;
import Toybox.Communications;
import Toybox.Lang;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

(:background :background_app)
class BgbgServiceDelegate extends Toybox.System.ServiceDelegate {

	function initialize() {
		System.ServiceDelegate.initialize();
		inBackground=true;				//trick for onExit()
        // Background.exit("this works");
	}

	function onTemporalEvent() as Void {
		// var url = "https://localhost:8443/";
        var url = "https://api.jsonbin.io/v3/b/65cc1fd01f5677401f2ef548";

        var params = {};

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
                "Content-Type" => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
                "X-Access-Key" => "$2a$10$Vm5SBIfh1mmTtT8lW1kFiuY2c2vmh1QrdmcskFKBYRYYOnpIwADN6"
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

		Communications.makeWebRequest(url, params, options, self.method(:responseCallback));
    }

    function responseCallback(responseCode as Number, data as Dictionary?) as Void {
        // Do stuff with the response data here and send the data
        // payload back to the app that originated the background
        // process.
		if (responseCode == 200) {
			System.println("Response: " + data);
            Background.exit(data.get("record"));

		} else {
			System.println("Error: " + responseCode);
			Background.exit(null);
		}
    }
}
