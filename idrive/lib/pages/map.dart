import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vector_math/vector_math.dart';

class MapPage extends StatefulWidget {
  static const path = "/map";
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FlutterTts tts = FlutterTts();
  //state of the vehicles
  List vehicleStateList = [];
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor pinLocationIcon;

  Set<Marker> _markers = {};

  //Loader
  bool _isLoading = true;

  //TImer
  late Timer _timer;

  CameraPosition initialLocation = CameraPosition(
    zoom: 14,
    bearing: 30,
    target: LatLng(6.074242, 80.288705),
  );

  @override
  void initState() {
    // set the car pin icon as a BitmapDescriptor for the marker
    getBytesFromAsset('assets/images/car_pin.png', 100).then((value) {
      Uint8List markerIcon = value;
      pinLocationIcon = BitmapDescriptor.fromBytes(markerIcon);
    });

    // configure the TTS library
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);

    super.initState();
    // context.loaderOverlay.show();
  }

  //Dispose Timer and TTS on page close
  @override
  void dispose() async {
    super.dispose();
    await tts.stop();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_outlined),
        ),
        title: Text(
          "Google Maps",
          style: Theme.of(context).textTheme.headline6,
        ),
        elevation: 0,
      ),
      body: LoaderOverlay(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

            //Set a loader for the first execution
            if (_isLoading == true) context.loaderOverlay.show();

            // set a timer to add a random car every 30 seconds
            _timer = Timer.periodic(Duration(seconds: 20), (Timer t) async {
              int _vIndex = 0;
              bool _isHighAcc;

              //Read Vehicle data from the API
              var vehicles = await getVehiclesFromAPI();

              //Set the initial state for Vehicles
              if (vehicleStateList.length == 0) {
                setState(() {
                  vehicleStateList = vehicles;
                });
              }

              for (int i = 0; i < vehicles.length; i++) {
                //Reset the acceleraton state
                _isHighAcc = false;

                //Get the state for this vehicle
                for (int j = 0; j < vehicleStateList.length; j++) {
                  if (vehicleStateList[j]['id'] == vehicles[i]['id']) {
                    _vIndex = j;
                  }
                }

                //Draw the marker
                addNewMarker(
                    vehicles[i]['label'].toString(),
                    vehicles[i]['lat'],
                    vehicles[i]['lon'],
                    vehicles[i]['speed']);

                //Hide the loader
                //Hide it after rendering markers
                if (_isLoading == true) {
                  _isLoading = false;
                  context.loaderOverlay.hide();
                }

                //Set Acceleration
                //Giving the priority to the acceleration
                var _prevVelocity = vehicleStateList[_vIndex]['speed'];
                var _currentVelocity = vehicles[i]['speed'];
                var _velocityDiff = _currentVelocity - _prevVelocity;
                var _acceleration =
                    _velocityDiff / (20 / 3600); //Seconds to hours
                if ((_acceleration - vehicleStateList[_vIndex]['prevAcc']) >
                        0 &&
                    (_acceleration - vehicleStateList[_vIndex]['prevAcc']) >
                        5) {
                  _isHighAcc = true;
                } else {
                  _isHighAcc = false;
                }

                //Acceleration Warning
                if (_isHighAcc == true) speakHighAcceleration();

                //Check High Speed
                if (vehicles[i]['speed'] > 100 && _isHighAcc != true) {
                  highSpeedMovement(vehicles[i]['lat'], vehicles[i]['lon'],
                      vehicles[i]['speed']);
                }

                print(vehicles[i].toString()); //DEBUG

                //Reset the prev velocity and acceleration
                vehicleStateList[_vIndex]['speed'] = vehicles[i]['speed'];
                vehicleStateList[_vIndex]['prevAcc'] = _acceleration;
              }
              //refresh
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  addNewMarker(
      String carName, double locationLat, double locationLon, int speed) {
    _markers.add(
      Marker(
        infoWindow: InfoWindow(
          title: carName,
          snippet: "$speed kmph",
        ),
        markerId:
            MarkerId("$carName $LatLng(locationLat, locationLon) - $speed"),
        position: LatLng(locationLat, locationLon),
        icon: pinLocationIcon,
      ),
    );
    return;
  }

  highSpeedMovement(double locationLat, double locationLon, int speed) {
    // High Speed Car camera movement
    _controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition((CameraPosition(
        target: LatLng(locationLat, locationLon),
        zoom: 16,
        bearing: 30,
      ))));
    });
    speakHighSpeed(speed.toString());
  }

  speakHighSpeed(String speed) {
    tts.speak("A vehicle nearby is at $speed kilometres per hour");
  }

  speakHighAcceleration() {
    tts.speak("A vehicle nearby is gaining sudden acceleration!");
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future getVehiclesFromAPI() async {
    try {
      var response = await Dio().get(
          'https://idrive-b6298-default-rtdb.firebaseio.com/vehicles.json');
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
