import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idrive/shared/app_bar.dart';
import 'package:idrive/shared/logo.dart';
import 'package:sizer/sizer.dart';

class ObdSkipPage extends StatelessWidget {
    static const path = "/obdskip";

  ObdSkipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: buildAppBar(context),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildLogo(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Why is safety important while driving?",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2.h, 0, 0),
                      child: Text(
                        """It is important to drive safely because it can save your life, help avoid hefty fines or imprisonment for traffic violations and keep your insurance premiums lower. Safe driving is crucial because things can happen behind the wheel in a split second.”""",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.grey, fontSize: 10.sp),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
