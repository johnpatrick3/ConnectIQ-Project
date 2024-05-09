import Toybox.Application;
import Toybox.Graphics;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Complications;

var font_hour;
var font_min;
var dw = 0;
var dh = 0;
var heartIcon, bodyBatteryIcon, temperatureIcon, batteryStatusIcon;

class FirstWatchFaceProjectView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        dw = dc.getWidth();
        dh = dc.getHeight();
        
        defineComplicationBoxes(dc);
        heartIcon = WatchUi.loadResource(Rez.Drawables.heart);
        bodyBatteryIcon = WatchUi.loadResource(Rez.Drawables.body);
        temperatureIcon = WatchUi.loadResource(Rez.Drawables.temperature);
        batteryStatusIcon = [
            WatchUi.loadResource(Rez.Drawables.Battery_100), 
            WatchUi.loadResource(Rez.Drawables.Battery_80), 
            WatchUi.loadResource(Rez.Drawables.Battery_60),
            WatchUi.loadResource(Rez.Drawables.Battery_40),
            WatchUi.loadResource(Rez.Drawables.Battery_20)
        ];
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        
        setTime();
        setDate();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        drawComplicationBoxes(dc);
        setHR(dc);
        setBodyBattery(dc);
        setTemperature(dc);
        setBattery(dc);
        
        

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

    hidden function setTime() {
        
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
        var hourLabel = View.findDrawableById("HourLabel") as Text;
        var minuteLabel = View.findDrawableById("MinLabel") as Text;
        hourLabel.setText(hourString);
        minuteLabel.setText(minString);
        //dc.setColor(Graphics.COLOR_BLACK);
        //dc.drawText((dc.getWidth() / 2) - 70,(dc.getHeight() / 2) - 80,font_hour, hourString, Graphics.TEXT_JUSTIFY_CENTER);
        //dc.drawText((dc.getWidth() / 2) + 70,(dc.getHeight() / 2) - 65,font_min, minString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    hidden function setHR(dc) {

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
        dc.drawBitmap((boundingBoxes[2]["bounds"][0]-16), (boundingBoxes[2]["bounds"][1]-35),heartIcon);
        
    }

    hidden function setBodyBattery(dc) {

        var bodyBatteryComplication = Complications.getComplication(
           new Id(Complications.COMPLICATION_TYPE_BODY_BATTERY)
        );
        
        var bodyBatteryLabel = View.findDrawableById("BodyBattery") as Text;
        var bodyBatteryValue = "--";
        if (bodyBatteryComplication.value != null) {
            bodyBatteryValue = bodyBatteryComplication.value.toString();
        }
        bodyBatteryLabel.setText(bodyBatteryValue);
        dc.drawBitmap((boundingBoxes[3]["bounds"][0]-16), (boundingBoxes[3]["bounds"][1]-35),bodyBatteryIcon);
    }

    hidden function setTemperature(dc) {

        var temperatureComplication = Complications.getComplication(
           new Id(Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE)
        );
        
        var tempLabel = View.findDrawableById("TempLabel") as Text;
        var tempValue = "--";
        if (temperatureComplication.value != null) {
            tempValue = (((temperatureComplication.value) * (9/5)) + 32).toString();
        }
        tempLabel.setText(tempValue);
        dc.drawBitmap((boundingBoxes[0]["bounds"][0]-12), (boundingBoxes[0]["bounds"][1]-33),temperatureIcon);
    }

     hidden function setBattery(dc) {

        var batteryComplication = Complications.getComplication(
           new Id(Complications.COMPLICATION_TYPE_BATTERY)
        );
        
        var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
        var batteryValue = "--";
        if (batteryComplication.value != null) {
            batteryValue = batteryComplication.value.toString() + "%";
        }
        batteryLabel.setText(batteryValue);

        if ((batteryComplication.value > 80) or (batteryComplication.value == null)) {
            
            dc.drawBitmap((boundingBoxes[1]["bounds"][0]-16), (boundingBoxes[1]["bounds"][1]-33),batteryStatusIcon[0]);
        }
        else if (batteryComplication.value > 60) {
            dc.drawBitmap((boundingBoxes[1]["bounds"][0]-12), (boundingBoxes[1]["bounds"][1]-33),batteryStatusIcon[1]);
        }
        else if (batteryComplication.value > 40) {
            dc.drawBitmap((boundingBoxes[1]["bounds"][0]-12), (boundingBoxes[1]["bounds"][1]-33),batteryStatusIcon[2]);
        }
        else if (batteryComplication.value > 20) {
            dc.drawBitmap((boundingBoxes[1]["bounds"][0]-12), (boundingBoxes[1]["bounds"][1]-33),batteryStatusIcon[3]);
        }
        else if (batteryComplication.value > 0) {
            dc.drawBitmap((boundingBoxes[1]["bounds"][0]-12), (boundingBoxes[1]["bounds"][1]-33),batteryStatusIcon[4]);
        }

    }

    hidden function setDate() {

        var dateComplication = Complications.getComplication(
            new Id(Complications.COMPLICATION_TYPE_DATE)
        );
        
        var dateLabel = View.findDrawableById("Date") as Text;
        var dateValue = "--";
        if (dateComplication.value != null) {
            dateValue = dateComplication.value.toString();
        }
        dateLabel.setText(dateValue);
    }

    hidden function drawComplicationBoxes(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.setPenWidth(3);
        for (var i=0;i < boundingBoxes.size();i++) {
            dc.drawCircle(boundingBoxes[i]["bounds"][0],boundingBoxes[i]["bounds"][1],boundingBoxes[i]["bounds"][2]);
        }
        
    }

    function defineComplicationBoxes(dc) {

        var radius = 40;

        boundingBoxes = [
            {
                "label" => "Temperature",
                "bounds" => [dw/4,dh/4.5,radius],
                "ComplicationId" => Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE
            },
            {
                "label" => "Battery",
                "bounds" => [dw*3/4,dh/4.5,radius],
                "ComplicationId" => Complications.COMPLICATION_TYPE_BATTERY
            },
            {
                "label" => "HeartRate",
                "bounds" => [dw/4,dh*3/3.75,radius],
                "ComplicationId" => Complications.COMPLICATION_TYPE_HEART_RATE
            },
            {
                "label" => "BodyBattery",
                "bounds" => [dw*3/4,dh*3/3.75,radius],
                "ComplicationId" => Complications.COMPLICATION_TYPE_BODY_BATTERY
            }
        ];
    }
}
