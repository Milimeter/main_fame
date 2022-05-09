import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:login_signup_screen/constants/firebase.dart';
import 'package:login_signup_screen/controllers/algorand_controller.dart';
import 'package:login_signup_screen/controllers/app_controller.dart';
import 'package:login_signup_screen/controllers/feeds_controller.dart';
import 'package:login_signup_screen/controllers/user_controller.dart';
import 'package:login_signup_screen/widgets/custom_text.dart';

import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization.then((value) {
    print("initialized firebase");
  });
  await GetStorage.init();
  Get.put(UserController());

  Get.put(AppController());
  Get.put(FeedsController());
  Get.put(AlgorandController());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarBrightness: Brightness.light,
    statusBarColor: kPrimaryColor,
  ));

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    theme: ThemeData(
      brightness: Brightness.light,
      fontFamily: "AvenirNext-Medium",
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: kPrimaryColor,
    ),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Center(
                  child: Image.asset("assets/algo2.png"),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                child: CText(
                  text: "Powered by Fame",
                  color: kWhiteColor,
                  size: 15,
                  fontFamily: "AvenirNext-UltraLight",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
