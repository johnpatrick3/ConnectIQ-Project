import Toybox.Application;
import Toybox.Graphics;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Complications;

var font;

class FirstWatchFaceProjectView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
        //var hasHr = (ActivityMonitor has :getHeartRateHistory);   
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        font = WatchUi.loadResource(Rez.Fonts.superfun);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        
        setHR();
        setBodyBattery();
        setTemperature();
        setBattery();
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        setTime(dc);
        
        

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

    hidden function setTime(dc) {
        
        //var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (System.getDeviceSettings().is24Hour) {
                //timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var hourString = hours.format("%02d");
        var minString = minutes.format("%02d");
        //var hourLabel = View.findDrawableById("HourLabel") as Text;
        //var minuteLabel = View.findDrawableById("MinLabel") as Text;
        //hourLabel.setText(hourString);
        //minuteLabel.setText(minString);

        dc.drawText(130,190,font, hourString, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(340,190,font, minString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    hidden function setHR() {

        var hr = "--";
        var newHr = Activity.getActivityInfo().currentHeartRate;
        if(newHr == null) {
            var hrh = ActivityMonitor.getHeartRateHistory(1,true);
            if(hrh != null) {
                var hrs=hrh.next();
                if(hrs != null && hrs.heartRate != null && hrs.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                    newHr = hrs.heartRate;
                }
            }
        }
        if(newHr != null) {
            hr = newHr;
        }

        var heartRateLabel = View.findDrawableById("HeartRate") as Text;
        heartRateLabel.setText(hr.toString());
    }

    hidden function setBodyBattery() {

        var bodyBatteryComplication = Complications.getComplication(
           new Id(Complications.COMPLICATION_TYPE_BODY_BATTERY)
        );
        
        var bodyBatteryLabel = View.findDrawableById("BodyBattery") as Text;
        var bodyBatteryValue = "--";
        if (bodyBatteryComplication.value != null) {
            bodyBatteryValue = bodyBatteryComplication.value.toString();
        }
        bodyBatteryLabel.setText(bodyBatteryValue);
    
    }

    hidden function setTemperature() {

        var temperatureComplication = Complications.getComplication(
           new Id(Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE)
        );
        
        var tempLabel = View.findDrawableById("TempLabel") as Text;
        var tempValue = "--";
        if (temperatureComplication.value != null) {
            tempValue = (((temperatureComplication.value) * (9/5)) + 32).toString();
        }
        tempLabel.setText(tempValue);

    }

     hidden function setBattery() {

        var batteryComplication = Complications.getComplication(
           new Id(Complications.COMPLICATION_TYPE_BATTERY)
        );
        
        var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
        var batteryValue = "--";
        if (batteryComplication.value != null) {
            batteryValue = batteryComplication.value.toString();
        }
        batteryLabel.setText(batteryValue + "%");

    }


}
