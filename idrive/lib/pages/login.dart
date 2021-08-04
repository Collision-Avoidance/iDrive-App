import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idrive/service/auth.dart';
import 'package:idrive/shared/app_bar.dart';
import 'package:idrive/shared/dialog.dart';
import 'package:idrive/shared/footer.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
    static const path = "/login";

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: buildAppBar(context),
      body: GestureDetector(
        onTap: () {
          // To minimize the keyboard when the user taps anywhere else on the screen
          FocusScope.of(context).unfocus();
        },
        // In order to not cause out of bound errors when the keyboard pops out
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 12.h,
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildLoginForm(),
                  buildFooter(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5.h,
            horizontal: 5.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Login",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                child: Text(
                  "Please sign in to continue",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.grey,
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Expanded(
      flex: 3,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
              child: TextField(
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => _email = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 10.w),
              child: TextField(
                style: TextStyle(color: Colors.grey),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => _password = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var result = await new AuthService()
                        .signInWithEmailAndPassword(_email, _password);

                    if (result != null) {
                      Navigator.pushNamed(context, '/dashboard');
                    } else {
                      showAlertDialog(context, "Error", "Firebase Login Error");
                    }
                  },
                  child: Text("Login".toUpperCase()),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(4.w),
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
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account?   ",
                        style: Theme.of(context).textTheme.subtitle2,
                        children: <InlineSpan>[
                          TextSpan(
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName('/'));
                                Navigator.pushNamed(context, '/signup');
                              },
                            text: "Sign Up now",
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 14.sp,
                                    ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
