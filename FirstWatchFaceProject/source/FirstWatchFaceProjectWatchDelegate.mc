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

    public function onPress(clickEvent as WatchUi.ClickEvent) {

        var coords = clickEvent.getCoordinates();
        
        var complicationIdPressed = checkPressedComplication(coords);
        
        if (complicationIdPressed[0] != false) {
            
            var pressedComplication = new Complications.Id(complicationIdPressed[1]);
            if(pressedComplication) {
                Complications.exitTo(pressedComplication);
            }
            return(true);
        }
        return(false);
    }

}


