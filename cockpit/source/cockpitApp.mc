using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class cockpitApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
		//Play sound when starting application
		Attention.playTone(Attention.TONE_START);
		//Initialize geolocalization
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
		//Initialize sensors
		Sensor.setEnabledSensors( [Sensor.SENSOR_TEMPERATURE,Sensor.SENSOR_HEARTRATE] );
  		Sensor.enableSensorEvents( method(:onSensor) );
  		//Set boolean to tell view that no new data is available yet
  		App.getApp().setProperty("gpsSignalAcquired",false);
    }
    //Called when position data is gathered
    function onPosition(info) {
  		//Upload geolocalization data
		sendData(info);
		//Set boolean to tell view that new data is available
		App.getApp().setProperty("gpsSignalAcquired",true);
		//Tell UI to update itself
		WatchUi.requestUpdate();
	}
	//Called when sensor data is gathered
	function onSensor(sensorInfo) {
		
	}
	//Upload geolocalization data
	//Parameter is object with all position data
	function sendData(info) {
		//Get current time as timestamp in milliseconds
		//Get it as double since it's too big for number
		var time = Time.now().value().toDouble()*1000;
		//Get position data
		var latLng = info.position.toDegrees();
		var latitude = latLng[0];
		var longitude = latLng[1];
		var altitude = info.altitude;
		var speed = info.speed;
		var url = "https://data-projet-namib.mybluemix.net/watch_upload";
		//Set data to be sent as object
		var request = {"time" => time, "latitude" => latitude, "longitude" => longitude, "altitude" => altitude, "speed" => speed};
		//For each possible sensor, check wether its data is available
		if (Sensor.getInfo().temperature != null) {
			request.put("temperature", Sensor.getInfo().temperature);
		}
		if (Sensor.getInfo().heartRate != null) {
			request.put("heartrate", Sensor.getInfo().heartRate);
		}
		if (Sensor.getInfo().pressure != null) {
			request.put("pressure", Sensor.getInfo().pressure);
		}
		var options = {};
		//GET request with parameters - used to POST data
		Communications.makeJsonRequest(url, request, options, method(:responseCallback));
	}
	//Callback handler for JsonRequest
	function responseCallback(responseCode, data) {
		//Set response code as an application property
		App.getApp().setProperty("responseCode",responseCode);
		//Tell UI to update itself with response code
		WatchUi.requestUpdate();
	}

    //! onStop() is called when your application is exiting
    function onStop() {
    	//Stop geolocalization to preserve battery
    	Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:noMorePosition));
    	//Play sound
    	var music = Attention.playTone(Attention.TONE_STOP);
    }
    
    function noMorePosition(info) {}

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new cockpitView(), new cockpitDelegate() ];
    }

}

class cockpitDelegate extends Ui.BehaviorDelegate {

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new cockpitMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}