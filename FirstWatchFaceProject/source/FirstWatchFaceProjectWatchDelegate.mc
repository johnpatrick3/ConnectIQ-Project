using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.ActivityMonitor;
using Toybox.Timer;
using Toybox.Complications;

class WatchDelegate extends Toybox.WatchUi.WatchFaceDelegate {

    function initialize() {
        WatchFaceDelegate.initialize();
    }

    function onPress(clickEvent as WatchUi.ClickEvent) {

        var coords = clickEvent.getCoordinates();

        var complicationId = checkPressedComplication(coords);
    }

}


