import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_screen/utils/colors.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(color: kPrimaryColor),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(icon, color: kPrimaryColor),
        onPressed: () {},
      ),
    ],
  );
}
