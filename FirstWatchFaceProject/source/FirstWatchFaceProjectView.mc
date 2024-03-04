import Toybox.Application;
import Toybox.Graphics;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class FirstWatchFaceProjectView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
        var hasHr = (ActivityMonitor has :getHeartRateHistory);   
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(timeString);

        // collecting HR
        var view_hr = View.findDrawableById("HeartRate") as Text;
        //if(!hasHr) {return;}
        var hr = "--";
        var newHr=Activity.getActivityInfo().currentHeartRate;
        if(newHr==null) {
            var hrh=ActivityMonitor.getHeartRateHistory(1,true);
            if(hrh!=null) {
                var hrs=hrh.next();
                if(hrs!=null && hrs.heartRate!=null && hrs.heartRate!=ActivityMonitor.INVALID_HR_SAMPLE) {
                    newHr=hrs.heartRate;
                }
            }
        }
        if(newHr != null) {
            hr=newHr;
        }

        view_hr.setText(hr.toString());

        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        //dc.drawBitmap(0,0,myImage);
        

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
