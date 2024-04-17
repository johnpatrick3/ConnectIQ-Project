using Toybox.System;
using Toybox.Complications;

public var boundingBoxes = [];

function checkPressedComplication(coord_values) {
    var xvalue = 0;
    var yvalue = 0;

    for (var i=0;i<boundingBoxes.size();i++) {
        
        var currBounds = boundingBoxes[i]["bounds"];

        xvalue = coord_values[0];
        yvalue = coord_values[1];

        //add code to check if x or y value is in bounding box then return complication ID

    }

    

}