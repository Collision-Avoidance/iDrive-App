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
                      "Why should you connect to your OBD?",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2.h, 0, 0),
                      child: Text(
                        """OBD stands for On-Board Diagnostic. It’s the standardized system that allows external electronics to interface with a car’s computer system. It has become more important as cars have become increasingly computerized, and software has become the key to fixing many problems and unlocking performance.

OBD has existed in various forms long before anyone ever uttered the words “infotainment” or “connected car.”""",
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
