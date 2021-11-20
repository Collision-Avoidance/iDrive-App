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
import 'package:vector_math/vector_math.dart';

class MapPage extends StatefulWidget {
  static const path = "/map";
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FlutterTts tts = FlutterTts();
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor pinLocationIcon;

  Set<Marker> _markers = {};

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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          // set a timer to add a random car every 30 seconds
          Timer.periodic(Duration(seconds: 20), (Timer t) async {
            var vehicles = await getVehiclesFromAPI();
            for (int i = 0; i < vehicles.length; i++) {
              //Draw the marker
              addNewMarker(vehicles[i]['label'].toString(), vehicles[i]['lat'],
                  vehicles[i]['lon'], vehicles[i]['speed']);

              //Check High Speed
              if (vehicles[i]['speed'] > 100) {
                highSpeedMovement(vehicles[i]['lat'], vehicles[i]['lon'],
                    vehicles[i]['speed']);
              }

              //Set Acceleration
              var _prevVelocity = vehicles[i]['prevVelocity'];
              var _currentVelocity = vehicles[i]['speed'];
              var _velocityDiff = _currentVelocity - _prevVelocity;
              var _acceleration = _velocityDiff / 5;

              if ((vehicles[i]['prevAcc'] - _acceleration) > 0 &&
                  (vehicles[i]['prevAcc'] - _acceleration) > 10) {
                vehicles[i]['isAccWarning'] = true;
              } else {
                vehicles[i]['isAccWarning'] = false;
              }

              print(vehicles[i].toString());
              // vehiclesList.add(vehicles[i]);

              //Acceleration Warning
              if (vehicles[0]['isAccWarning']) speakHighAcceleration();

              //Reset the prev velocity and acceleration
              vehicles[i]['prevVelocity'] = vehicles[i]['speed'];
              vehicles[i]['prevAcc'] = _acceleration;
            }

            setState(() {});
          });
        },
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
      // print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
