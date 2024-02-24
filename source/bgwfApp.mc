using Toybox.Application as App;
using Toybox.Background;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
import Toybox.Lang;

// info about whats happening with the background process
var level = 1;
var canDoBG=false;
var inBackground=false;			//new 8-27

// keys to the object store data
var OSLEVEL=1;

(:background)
class bgwfApp extends App.AppBase {

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
            App.getApp().setProperty(OSLEVEL, level);
    	} else {
    		Sys.println("onStop");
    	}
    }

    // Return the initial view of your application here
    function getInitialView() {
    	Sys.println("getInitialView");
		//register for temporal events if they are supported
    	if(Toybox.System has :ServiceDelegate) {
    		canDoBG=true;
    		Background.registerForTemporalEvent(new Time.Duration(5 * 60));
    	} else {
    		Sys.println("****background not available on this device****");
    	}
        return [ new bgwfView() ];
    }

    function onBackgroundData(data) {
        if (data == null || !(data instanceof Lang.Dictionary)) {
            return;
        }
        level = data.get("level");
        OSLEVEL = level;
        App.getApp().setProperty(OSLEVEL, level);
        Ui.requestUpdate();
    }

    function getServiceDelegate(){
        return [new BgbgServiceDelegate()];
    }

    function onAppInstall() {
    	Sys.println("onAppInstall");
    }

    function onAppUpdate() {
    	Sys.println("onAppUpdate");
        Background.exit(null);
    }
}