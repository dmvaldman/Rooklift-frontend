using Toybox.Background;
using Toybox.System as System;
import Toybox.Communications;
import Toybox.Lang;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

(:background :background_app)
class BgServiceDelegate extends Toybox.System.ServiceDelegate {

	function initialize() {
		System.ServiceDelegate.initialize();
		inBackground=true;				//trick for onExit()
	}

	function onTemporalEvent() as Void {
        var url = "https://gist.githubusercontent.com/dmvaldman/bf74b84b8d6088169325f168b646e148/raw/2d5925f857affdf6b3b83838ecb0b71a5b6e9993/rooklift.json";

        var params = {};
        var token = "token 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";

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
                "Content-Type" => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
                "Authorization" => token
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

		Communications.makeWebRequest(url, params, options, self.method(:responseCallback));
    }

    function responseCallback(responseCode as Number, data as Dictionary?) as Void {
		if (responseCode == 200) {
			System.println("Response: " + data);
            Background.exit(data);

		} else {
			System.println("Error: " + responseCode);
			Background.exit(null);
		}
    }
}
