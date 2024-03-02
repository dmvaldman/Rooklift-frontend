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

    (:glance) function getGlanceView() {
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
    	if(Toybox.System has :ServiceDelegate) {
    		canDoBG=true;
    		Background.registerForTemporalEvent(new Time.Duration(5 * 60));
    	} else {
    		Sys.println("****background not available on this device****");
    	}
        return [ new RookLiftView() ];
    }

    function onBackgroundData(data) {
        if (data == null || !(data instanceof Lang.Dictionary)) {
            return;
        }
        // from background process
        level = data.get("level");
        metrics = data.get("metrics");

        // for development
        // level = getRandomInteger();
        // metrics = "Metrics: " + level;

        App.Storage.setValue("level", level);
        App.Storage.setValue("metrics", metrics);

        // update both the glance view and app view
        WatchUi.requestUpdate();
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