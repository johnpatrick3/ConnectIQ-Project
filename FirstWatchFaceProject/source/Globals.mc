using Toybox.System;
using Toybox.Complications;

public var boundingBoxes = [];
var radius;

function checkPressedComplication(coord_values) {
    var xvalue = coord_values[0];
    var yvalue = coord_values[1];

    for (var i=0;i<boundingBoxes.size();i++) {
        
        var currBounds = boundingBoxes[i]["bounds"];

        if((xvalue - currBounds[0])*(xvalue - currBounds[0]) + (yvalue - currBounds[1])*(yvalue - currBounds[1]) <= currBounds[2]*currBounds[2]) {
            return boundingBoxes[i]["ComplicationId"];
        }

    }

    return false;
    

}