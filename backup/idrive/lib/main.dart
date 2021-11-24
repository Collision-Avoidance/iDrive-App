import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idrive/pages/connect_obd_splash.dart';
import 'package:idrive/pages/dashboard.dart';
import 'package:idrive/pages/login.dart';
import 'package:idrive/pages/map.dart';
import 'package:idrive/pages/obd_skip.dart';
import 'package:idrive/pages/search_obd.dart';
import 'package:idrive/pages/signup.dart';
import 'package:idrive/pages/splash.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'iDrive',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context)
                .textTheme
                .apply(displayColor: Colors.white, bodyColor: Colors.white)
                .copyWith(
                  headline4: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontSize: 25.sp),
                  subtitle2: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 10.sp, color: Colors.white),
                  headline6: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 14.sp, color: Colors.white),
                ),
          ),
        ),
        home: SplashPage(),
        initialRoute: '/',
        routes: {
          LoginPage.path: (context) => LoginPage(),
          SignUpPage.path: (context) => SignUpPage(),
          DashboardPage.path: (context) => DashboardPage(),
          ConnectOBDSplashPage.path: (context) => ConnectOBDSplashPage(),
          ObdSkipPage.path: (context) => ObdSkipPage(),
          SearchOBDPage.path: (context) => SearchOBDPage(),
          MapPage.path: (context) => MapPage(),
        },
      );
    });
  }
}
