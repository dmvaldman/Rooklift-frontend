using Toybox.Background;
using Toybox.System as System;
import Toybox.Communications;
import Toybox.Lang;


// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

// (:background :background_app)
// function createMetrics() {
//     var metrics = [
//         ["Stress duration", {"importance" => 0.2924777228545125, "level" => 0.16839134524929444}],
//         ["Rem duration", {"importance" => 0.2633057920897726, "level" => 0.26632613616135203}],
//         ["Stress avg", {"importance" => 0.20458103135703173, "level" => 1.569786215303474}],
//         ["Body battery", {"importance" => 0.05846659091872788, "level" => 0.41804058769767394}],
//         ["Deep duration", {"importance" => -0.06438215443230628, "level" => 0.6216489629114663}],
//         ["Activity calories", {"importance" => -0.1636114725265584, "level" => 0.22030096697664764}],
//         ["Light duration", {"importance" => -0.17824453927200715, "level" => 0.5693362853122927}]
//     ];
//     return metrics;
// }

// (:background :background_app)
// function createJsonObject() {
//     var mainObject = {"level" => 0.7297699298559802, "metrics" => createMetrics()};
//     return mainObject;
// }

(:background :background_app)
class BgServiceDelegate extends Toybox.System.ServiceDelegate {

	function initialize() {
		System.ServiceDelegate.initialize();
		inBackground=true;				//trick for onExit()
	}

	function onTemporalEvent() as Void {
        // var data = createJsonObject();
        // responseCallback(200, data);

        var url = "https://rooklift.s3.us-west-1.amazonaws.com/rooklift.json";

        var params = {};
        var response_type = Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN;

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
                "Content-Type" => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            :responseType => response_type
        };

		Communications.makeWebRequest(url, params, options, self.method(:responseCallback));
    }

    function responseCallback(responseCode as Number, data as Dictionary?) as Void {
		if (responseCode == 200) {
			System.println("Response: " + data);
            Background.exit(data);
		} else {
			System.println("Error in responseCallback: " + responseCode);
			Background.exit(null);
		}
    }
}
