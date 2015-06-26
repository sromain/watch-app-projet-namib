using Toybox.WatchUi as Ui;
//using Toybox as Toy;

class cockpitView extends Ui.View {

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	
		//View.findDrawableById("codeField").setText("lore ipsum");
    }
    
    
    
    
    //! Update the view
    function onUpdate(dc) {
    	
    	var statusString = "";
    	var latString = "";
    	var lngString= "";
    	var headingString = "";
    	//Check if watch has initialized GPS for new data
    	if (Application.getApp().getProperty("gpsSignalAcquired")) {
    		//Get latest positioning data
	    	var latLng = Position.getInfo().position;
	    	if (latLng != null) {
	    		var latLngArray = latLng.toDegrees();
	    		latString = "Latitude: "+latLngArray[0];
	    		lngString = "Longitude: "+latLngArray[1];
	    	}
	    	//Get latest heading data
	    	var heading = Position.getInfo().heading;
	    	if (heading != null) {
	    		headingString = "Direction:"+heading;
	    	}
	    	//Get latest data upload response code
	    	var code = Application.getApp().getProperty("responseCode");
	    	//Display adequate message if upload was successful
	    	if (code == 200) {
	    		statusString = "Connexion reussie";
	    	//If upload failed
	    	} else {
	    		statusString = "Echec de la connexon";
	    	}
	    	//Assign values to labels in layout
	    	View.findDrawableById("statusField").setText(statusString);
	    	View.findDrawableById("latField").setText(latString);
	    	View.findDrawableById("lngField").setText(lngString);
	    	View.findDrawableById("headingField").setText(headingString);
	    }
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    
    }

}