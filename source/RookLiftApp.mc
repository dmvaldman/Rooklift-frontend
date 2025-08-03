using Toybox.Application as App;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Time as Time;
import Toybox.WatchUi;
import Toybox.Lang;

// info about whats happening with the background process
var level = 0.6;
var metrics = [];

var canDoBG=false;
var inBackground=false;

(:background)
class RookLiftApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
		Sys.println("onStart");
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	//moved from onHide() - using the "is this background" trick
    	if(!inBackground) {
            App.Storage.setValue("level", level);
            App.Storage.setValue("metrics", metrics);
    	} else {
    		Sys.println("onStop");
    	}
    }

    function registerForBackgroundEvents() as Void {
        if (Toybox.System has :ServiceDelegate) {
            canDoBG = true;
            // Register for temporal events to run every 5 minutes
            var fiveMinutes = new Time.Duration(5 * 60);
            Background.registerForTemporalEvent(fiveMinutes);

            // Register for wake events if supported
            if (Toybox.Background has :registerForWakeEvent) {
                try {
                    Background.registerForWakeEvent();
                } catch (ex) {
                    Sys.println("Wake events not supported on this device: " + ex.getErrorMessage());
                }
            } else {
                Sys.println("Wake events not available on this device");
            }
        } else {
            Sys.println("****background not available on this device****");
        }
    }

    (:glance) function getGlanceView() {
        registerForBackgroundEvents();
        return [ new RoofLiftGlanceView() ];
    }

    function getRandomInteger() {
        var randomNumber = Math.rand();

        // Use modulus to limit the range to 0-5, then add 1 to shift to 1-6
        var adjustedNumber = (randomNumber % 6) + 1;

        return adjustedNumber;
    }

    // Return the initial view of your application here
    function getInitialView() {
		//register for temporal events if they are supported
    	registerForBackgroundEvents();

        // Make wake event request when user opens the app
        makeWakeRequest();

        return [ new RookLiftView() ];
    }

    function makeWakeRequest() as Void {
        // Check if we've already made a request today
        var lastRequestDate = App.Storage.getValue("lastWakeRequestDate");
        var today = Time.now();
        var todayDate = today.value() / (24 * 60 * 60); // Days since epoch

        // Check if we've already made a request today
        if (lastRequestDate != null && lastRequestDate == todayDate) {
            Sys.println("Wake request already made today, skipping");
            return;
        }

        // Store today's date
        App.Storage.setValue("lastWakeRequestDate", todayDate);

        // Webhook URL for running today's prediction
        var url = "https://dmvaldman--rooklift-predict-webhook.modal.run/";

        var params = {};
        var response_type = Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON;

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            :responseType => response_type
        };

        Communications.makeWebRequest(url, params, options, self.method(:onWakeResponse));
    }

    function updateUI(data as Dictionary?) as Void {
        if (data == null || !(data instanceof Lang.Dictionary)) {
            return;
        }
        // from background process
        level = data.get("level");
        metrics = data.get("metrics");

        if (level > 1) {
            level = 1;
        }

        // for development
        // level = getRandomInteger();
        // metrics = "Metrics: " + level;

        App.Storage.setValue("level", level);
        App.Storage.setValue("metrics", metrics);

        // update both the glance view and app view
        WatchUi.requestUpdate();
    }

    function onWakeResponse(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            Sys.println("Wake request successful: " + data);
            updateUI(data);
        } else {
            Sys.println("Wake request error: " + responseCode);
        }
    }

    function onBackgroundData(data) {
        updateUI(data);
    }

    function getServiceDelegate(){
        return [new BgServiceDelegate()];
    }

    function onAppInstall() {
    	Sys.println("onAppInstall");
    }

    function onAppUpdate() {
    	Sys.println("onAppUpdate");
        Background.exit(null);
    }
}