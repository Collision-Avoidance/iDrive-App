import 'package:flutter/material.dart';
import 'package:idrive/shared/app_bar.dart';
import 'package:idrive/shared/logo.dart';
import 'package:sizer/sizer.dart';

class ConnectOBDSplashPage extends StatefulWidget {
  static const path = "/connectobdsplash";

  ConnectOBDSplashPage({Key? key}) : super(key: key);

  @override
  _ConnectOBDSplashPageState createState() => _ConnectOBDSplashPageState();
}

class _ConnectOBDSplashPageState extends State<ConnectOBDSplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
          child: Column(
        children: [
          buildLogo(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  text: "Connect to your ",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "OBD",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/searchobd');
                    },
                    child: Text("Connect".toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      elevation: 0,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/obdskip');
                    },
                    child: Text("SKIP".toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      elevation: 0,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      )),
    );
  }
}
