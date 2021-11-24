import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idrive/shared/logo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  static const path = "/dashboard";

  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildLogo(),
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConnectToOBDButton(),
                     _buildOBDSystem(),
                    _buildSpeedPrediction(),
                    _buildConnectToMapButton(),
                    _buildAccessPhoneButton(),
                    _buildAccessCameraButton(),
                   
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildConnectToOBDButton() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/connectobdsplash'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.red,
                child: Container(
                  margin: EdgeInsets.all(2.h),
                  child: Image(
                    image: AssetImage('assets/images/car.png'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    "Select Manufacturer",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildOBDSystem() {
    return GestureDetector(
      onTap: () async {
      
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.purple,
                child: Container(
                  margin: EdgeInsets.all(2.h),
                  child: Image(
                    image: AssetImage('assets/images/obd.png'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    "Connect to OBD",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedPrediction() {
    return GestureDetector(
      onTap: () async {
     Navigator.pushNamed(context, '/speed');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.pink,
                child: Container(
                  margin: EdgeInsets.all(2.h),
                  child: Image(
                    image: AssetImage('assets/images/speed.png'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    "Speed Prediction",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectToMapButton() {
    return GestureDetector(
      onTap: () async {
        // var mapSchema = 'geo:6.8931024,79.8540301';
        // if (await canLaunch(mapSchema)) {
        //   await launch(mapSchema);
        // } else {
        //   throw 'Could not launch $mapSchema';
        // }
        Navigator.pushNamed(context, '/map');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.blue,
                child: Container(
                  margin: EdgeInsets.all(2.h),
                  child: Image(
                    image: AssetImage('assets/images/map.png'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    "Connect to Map",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessPhoneButton() {
    return GestureDetector(
      onTap: () async {
        var phoneSchema = "tel://0123456789";
        if (await canLaunch(phoneSchema)) {
          await launch(phoneSchema);
        } else {
          throw 'Could not launch $phoneSchema';
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.amber,
                child: Container(
                  margin: EdgeInsets.all(2.h),
                  child: Image(
                    image: AssetImage('assets/images/phone.png'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    "Access Phone",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessCameraButton() {
    return GestureDetector(
      onTap: () async {
        final _picker = ImagePicker();
        final PickedFile? pickedFile =
            await _picker.getImage(source: ImageSource.camera);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.green,
                child: Container(
                  margin: EdgeInsets.all(2.h),
                  child: Image(
                    image: AssetImage('assets/images/camera.png'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    "Access Camera",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
