import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
using Toybox.Application as App;

(:glance)
class RoofLiftGlanceView extends WatchUi.GlanceView {
  var deviceWidth, deviceHeight;

  function initialize() {
    GlanceView.initialize();
  }

  function onLayout(dc as Graphics.Dc) as Void {
    deviceWidth=dc.getWidth();
    deviceHeight=dc.getHeight();
  }

  function onShow() as Void {
    level = App.Storage.getValue("level");
    metrics = App.Storage.getValue("metrics");
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    dc.clear();

    var font = Graphics.FONT_TINY;
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(0, 0, font, "ROOK LIFT", Graphics.TEXT_JUSTIFY_LEFT);

    var fontHeight = dc.getFontHeight(font);
    var graphicsHeight = 25;
    var graphicsWidth = deviceWidth;

    var maxStages = 4;
    var currStage = Math.floor(maxStages * level);

    var colors = [
      Graphics.COLOR_ORANGE,
      Graphics.COLOR_YELLOW,
      Graphics.COLOR_GREEN,
      Graphics.COLOR_BLUE
    ];

    var grayColor = Graphics.COLOR_LT_GRAY;

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

    var margin = Math.floor((deviceHeight - 2 * fontHeight - graphicsHeight) / 2);

    var x = 0;
    var y = fontHeight + margin;

    var rectGap = 4;
    var rectHeightMargin = 4;

    var rectHeight = graphicsHeight - 2 * rectHeightMargin;
    var rectWidth = graphicsWidth / (maxStages + 0.0) - rectGap;

    for (var stage = 0; stage < maxStages; stage++) {
      if (stage == currStage) {
        rectHeightMargin = 4;
      }
      else {
        rectHeightMargin = 0;
      }

      dc.setColor(colors[stage], Graphics.COLOR_BLACK);
      dc.fillRectangle(x, y - rectHeightMargin, rectWidth, rectHeight + 2 * rectHeightMargin);

      System.println("x: " + x + ", y:" + y + ", w:" + rectWidth + ", h:" + rectHeight);
      x += rectWidth + rectGap;
    }

    // draw vertical gray line at continuous level
    var location = graphicsWidth * level;
    var meterWidth = 3;
    rectHeightMargin = 7;
    dc.setColor(grayColor, Graphics.COLOR_BLACK);
    dc.fillRectangle(location - meterWidth/2, y - rectHeightMargin, meterWidth, rectHeight + 2 * rectHeightMargin);

    // draw level
    var level_str = ((Math.round(level * 100) / 100 )as String).toString().substring(0, 4);
    var command_str = (level > .5) ? "PLAY!" : "REST!";
    y = fontHeight + graphicsHeight + 2 * margin;
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(deviceWidth - 26, y, font, command_str, Graphics.TEXT_JUSTIFY_RIGHT);
    dc.drawText(0, y, font, level_str, Graphics.TEXT_JUSTIFY_LEFT);
  }
}