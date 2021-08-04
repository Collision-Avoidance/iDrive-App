import 'package:flutter/material.dart';

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_outlined),
      ),
      elevation: 0,
    );
  }