using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class bgwfView extends Ui.WatchFace {

var width,height;

    function initialize() {
        WatchFace.initialize();
        var temp = App.getApp().getProperty(OSLEVEL);
        if (temp == null) {
            level = 0;
        }
        else {
            level = temp;
        }
    }

    // Load your resources here
    function onLayout(dc) {
        width=dc.getWidth();
        height=dc.getHeight();
     }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		dc.clear();
        dc.setPenWidth(30);

        if (OSLEVEL == 1) {
            dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_TRANSPARENT);
        }
        else if (OSLEVEL == 2) {
            dc.setColor(Gfx.COLOR_ORANGE,Gfx.COLOR_TRANSPARENT);
        }
        else if (OSLEVEL <= 4) {
            dc.setColor(Gfx.COLOR_YELLOW,Gfx.COLOR_TRANSPARENT);
        }
        else {
            dc.setColor(Gfx.COLOR_GREEN,Gfx.COLOR_TRANSPARENT);
        }

		dc.drawText(width/2, height/2,Gfx.FONT_TINY,"Chess Strength\n"+OSLEVEL,Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawArc(width/2, height/2, width/3, Gfx.ARC_CLOCKWISE, 0, 360 - OSLEVEL * 60);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	//may not be called on real watch  Moved to onStop()
    	//var now=Sys.getClockTime();
    	//var ts=now.hour+":"+now.min.format("%02d");
        //Sys.println("onHide counter="+counter+" "+ts);
    	//App.getApp().setProperty(OSCOUNTER, counter);
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
