import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
using Toybox.Graphics;
using Toybox.Application as App;
using Toybox.Math;

class RookLiftView extends WatchUi.View {
    var width, height;

    function initialize() {
        View.initialize();
        level = App.Storage.getValue("level");
        metrics = App.Storage.getValue("metrics");
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
        level = App.Storage.getValue("level");
        metrics = App.Storage.getValue("metrics");
    }

    function max(a, b) {
        return a > b ? a : b;
    }

    function min(a, b) {
        return a < b ? a : b;
    }

    // Update the view
    function onUpdate(dc) {
        dc.clear();

        var font = Graphics.FONT_XTINY;
        var fontHeight = dc.getFontHeight(font);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (metrics == null) {
            dc.drawText(width/2, height/2, font, "No metrics to display", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
            return;
        }

        var rectWidth = width/5;
        var rectHeight = fontHeight;
        var x = width/2 + 44;
        var y = height/6;
        var margin = 6;

        // loop through metrics
        for (var i = 0; i < metrics.size(); i++) {
            var metric = metrics[i];
            var label = metric[0];
            var importance = metric[1].get("importance");
            var level = metric[1].get("level");

            // if importance is near 0, don't display (this is for sparse model fitting that zero-out unimportant features)
            if (importance < .0001) {
                continue;
            }

            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(x, y, rectWidth, rectHeight);

            // draw label
            var color = Graphics.COLOR_RED;
            if (level > 0) {
                color = Graphics.COLOR_GREEN;
            } else if (level > -.25) {
                color = Graphics.COLOR_YELLOW;
            }

            dc.setColor(color, Graphics.COLOR_TRANSPARENT);

            var textWidth = dc.getTextDimensions(label, font)[0];
            dc.drawText(x - textWidth - 64, y, font, label, Graphics.TEXT_JUSTIFY_LEFT);

            // clip level to -1 to 2
            if (level > 1.5) {
                level = 1.5;
            } else if (level < -.5) {
                level = -.5;
            }

            // draw level as vertical rectangle sliver
            var levelWidth = 8;
            var levelHeight = rectHeight;
            var levelX = x + (level * rectWidth) - levelWidth/2;
            var levelY = y + rectHeight/2 - levelHeight/2;

            dc.fillRectangle(levelX, levelY, levelWidth, levelHeight);

            // draw horizontal line through rectangle meeting level
            if (level > 1) {
                dc.drawLine(x + rectWidth, y + rectHeight/2, levelX, y + rectHeight/2);
            }
            else if (level < 0) {
                dc.drawLine(levelX, y + rectHeight/2, x, y + rectHeight/2);
            }

            y += rectHeight;
            y += margin;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
