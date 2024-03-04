import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {
    private var myImage;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
        myImage = Application.loadResource(Rez.Drawables.BackgroundIcon);
    }

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen 
        //dc.setColor(Graphics.COLOR_TRANSPARENT, getApp().getProperty("BackgroundColor") as Number);
        //dc.clear();
        dc.drawBitmap(0,0,myImage);
    }

}
