import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_signup_screen/constants/controllers.dart';
import 'package:login_signup_screen/screens/auth/signup.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/widgets/custom_text.dart';

import 'forgot_password.dart';
import 'phone_input.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  void validateAndSubmit() async {
    print("=====================performing login=================");
    if (_validateAndSave()) {
      try {
        userController.emailAndPasswordSignIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(18),
            width: scrWidth,
            height: scrHeight,
            color: kPrimaryColor,
            child: Column(
              children: [
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CText(
                    text: "Sign in",
                    fontWeight: FontWeight.w600,
                    size: 25,
                    color: kWhiteColor,
                    bold: true,
                    fontFamily: "AvenirNext-Bold",
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CText(
                    text: "Sign in to your account to continue",
                    color: kWhiteColor,
                    fontWeight: FontWeight.w600,
                    size: 14,
                    textAlign: TextAlign.start,
                    fontFamily: "AvenirNext-UltraLight",
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.only(top: scrHeight * 0.2),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: scrHeight * 0.05),
                          inputFile(
                              label: "Email",
                              controller:
                                  userController.emailTextEditingController),
                          SizedBox(height: scrHeight * 0.02),
                          inputFile(
                              label: "Password",
                              obscureText: true,
                              controller:
                                  userController.passwordTextEditingController),
                          SizedBox(height: scrHeight * 0.01),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ResetPasswordScreen());
                              },
                              child: Text("Forgot Password?"),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: scrHeight * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            validateAndSubmit();
                          },
                          color: kPrimaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: scrHeight * 0.01),
                    Align(
                      alignment: Alignment.center,
                      child: CText(
                        text: "-------or-------",
                        color: kBlackColor,
                        fontWeight: FontWeight.w600,
                        size: 14,
                        textAlign: TextAlign.start,
                        fontFamily: "AvenirNext-UltraLight",
                      ),
                    ),
                    SizedBox(height: scrHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Get.to(PhoneInput());
                          },
                          color: kPrimaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Login with Phone number",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: ()=> Get.to(PhoneInput()),
                    //   child: Text(" Login with Phone number")),
                    SizedBox(height: scrHeight * 0.1),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account?"),
                          Text(
                            " Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(top: 100),
                    //   height: 200,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: AssetImage("assets/background.png"),
                    //         fit: BoxFit.fitHeight),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// we will be creating a widget for text field
Widget inputFile(
    {label, obscureText = false, TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        validator: (val) {
          return val.isEmpty ? "Field Cannot be empty" : null;
        },
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}

class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    //
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
