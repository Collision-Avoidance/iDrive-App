import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:idrive/service/auth.dart';
import 'package:idrive/shared/app_bar.dart';
import 'package:idrive/shared/dialog.dart';
import 'package:idrive/shared/footer.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends StatefulWidget {
  static const path = "/signup";
   SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _fullName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: buildAppBar(context),
      body: SafeArea(
        child: GestureDetector(
          // To minimize the keyboard when the user taps anywhere else on the screen
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            // In order to not cause out of bound errors when the keyboard pops out
            child: Container(
              height: 90.h,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildSignUpForm(),
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
    return Container(
      width: double.infinity,
      child: Padding(
        padding:  EdgeInsets.symmetric(
          vertical: 10.w,
          horizontal: 10.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Sign Up",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(0, 1.h, 0, 0),
              child: Text(
                "Create a free account",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Expanded(
      flex: 2,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                   EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
              child: TextField(
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Enter your full name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => _fullName = value,
              ),
            ),
            Padding(
              padding:
                   EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
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
              padding:
                   EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
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
              padding:
                   EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
              child: TextField(
                style: TextStyle(color: Colors.grey),
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => _confirmPassword = value,
              ),
            ),
            Padding(
              padding:
                   EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_password != _confirmPassword) {
                      showAlertDialog(
                          context, "Error", "Passwords do not match");
                    } else {
                      var value = await new AuthService()
                          .registerWithEmailAndPassword(_email, _password);

                      if (value == null) {
                        showAlertDialog(
                            context, "Error", "Firebase Sign Up Error");
                      } else {
                        Navigator.pushNamed(context, '/dashboard');
                      }
                    }
                  },
                  child: Text("Sign Up".toUpperCase()),
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
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.all(1.h),
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account?   ",
                        style: Theme.of(context).textTheme.subtitle2,
                        children: <InlineSpan>[
                          TextSpan(
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName('/'));
                                Navigator.pushNamed(context, '/login');
                              },
                            text: "Sign In now",
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 18,
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
