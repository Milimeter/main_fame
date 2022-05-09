import 'package:flutter/material.dart';
import 'package:login_signup_screen/constants/controllers.dart';
import 'package:login_signup_screen/screens/auth/login.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/widgets/custom_text.dart';

class SignupPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  // performs signup
  validateAndSubmit() async {
    print("====================authentication process================");
    if (_validateAndSave()) {
      userController.signUp();
      // _showVerifyEmailSentDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0,
      //   brightness: Brightness.light,
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios,
      //       size: 20,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
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
                    text: "Sign up",
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
                    text: "Create a new account to continue",
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
                padding: EdgeInsets.symmetric(horizontal: 40),
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
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: scrHeight * 0.05),
                        inputFile(
                            label: "Name",
                            controller:
                                userController.nameTextEditingController),
                        SizedBox(height: scrHeight * 0.02),
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
                      ],
                    ),
                    SizedBox(height: scrHeight * 0.05),
                    Container(
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
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: scrHeight * 0.1),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account?"),
                          Text(
                            " Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )
                        ],
                      ),
                    )
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
                borderSide: BorderSide(color: Colors.grey[400]))),
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
