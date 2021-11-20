import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
  List<String> cars = [
    "Nissan GTR",
    "Honda Civic",
    "Bentley Azure",
    "Volkswagen Beetle",
    "Volkswagen Golf",
    "Volkswagen Passat",
    "Renault Megane",
    "Mahindra Xylo",
    "Peugeot 508",
    "Peugeot 407",
    "Peugeot 308",
    "Peugeot RCZ",
    "Volkswagen Jetta",
    "Honda Vezel",
    "Toyota Hybrid",
    "Range Rover",
    "Toyota Corella",
    "Audi Q3",
    "Audi Q5",
    "Audi Q7",
    "BMW 470",
    "Nissan Leaf",
    "Toyota Prius"
  ];

  CameraPosition initialLocation = CameraPosition(
    zoom: 14,
    bearing: 30,
    target: LatLng(6.7980117, 80.0396157),
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
          Timer.periodic(Duration(seconds: 30), (Timer t) {
            addNewMarker();

            // if we have more than 10 markers (car pins), stop the timer
            if (_markers.length > 10) {
              t.cancel();
            }

            setState(() {});
          });
        },
      ),
    );
  }

  LatLng generateRandomCoordinates() {
    var rng = new Random();
    double lat = initialLocation.target.latitude;
    double long = initialLocation.target.longitude;

    // convert radius from meters to degrees
    double r = 750 / 111300;

    // generate two uniform values
    double u = rng.nextDouble();
    double v = rng.nextDouble();

    // https://gis.stackexchange.com/questions/25877/generating-random-locations-nearby
    double w = r * sqrt(u);
    double t = 2 * pi * v;
    double x = w * cos(t);
    double y = w * sin(t);

    x = x / cos(radians(long));

    rng.nextInt(2) == 0 ? lat += x : lat -= y;
    rng.nextInt(2) == 0 ? long += x : long -= y;

    return LatLng(lat, long);
  }

  addNewMarker() {
    var rng = new Random();
    var carName = cars[rng.nextInt(cars.length)];
    var speed = rng.nextInt(2) == 0
        ? 20 + (rng.nextInt(100 - 20))
        : 100 + (rng.nextInt(140 - 100));
    var location = generateRandomCoordinates();

    _markers.add(
      Marker(
        infoWindow: InfoWindow(
          title: carName,
          snippet: "$speed kmph",
        ),
        markerId: MarkerId("$carName $location - $speed"),
        position: location,
        icon: pinLocationIcon,
      ),
    );

    // set the car's speed in kmph
    if (speed >= 100) {
      _controller.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition((CameraPosition(
          target: location,
          zoom: 16,
          bearing: 30,
        ))));
      });

      tts.speak("A vehicle nearby is at $speed kilometres per hour");
    }

    return;
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
}
