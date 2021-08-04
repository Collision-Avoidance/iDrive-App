import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const path = "/";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/dashboard');
          },
          child: Container(
            height: 225,
            width: 225,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: ExactAssetImage('assets/images/logo.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
