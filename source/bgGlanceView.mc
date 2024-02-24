import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class BGGlanceView extends WatchUi.GlanceView {

  function initialize() {
    GlanceView.initialize();
  }

  function onLayout(dc as Graphics.Dc) as Void {
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.drawText(
      0,
      0,
      Graphics.FONT_XTINY,
      "hello" as String,
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }
}