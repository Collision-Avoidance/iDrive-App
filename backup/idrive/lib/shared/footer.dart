
import 'package:flutter/material.dart';

Widget buildFooter(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "About Us",
          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.blue),
        ),
        Text(
          "Terms & Conditions",
          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.blue),
        ),
        Text(
          "Privacy",
          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.blue),
        )
      ],
    ),
  );
}