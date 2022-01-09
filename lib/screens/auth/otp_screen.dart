// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_signup_screen/constants/controllers.dart';
import 'package:login_signup_screen/constants/firebase.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'phone_input.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: kPrimaryColor.withOpacity(0.6),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: kPrimaryColor,
    ),
  );
  String code = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Verify phone",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Code is sent to " + widget.phone,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF818181),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildCodeNumberBox(
                              code.length > 0 ? code.substring(0, 1) : ""),
                          buildCodeNumberBox(
                              code.length > 1 ? code.substring(1, 2) : ""),
                          buildCodeNumberBox(
                              code.length > 2 ? code.substring(2, 3) : ""),
                          buildCodeNumberBox(
                              code.length > 3 ? code.substring(3, 4) : ""),
                          buildCodeNumberBox(
                              code.length > 4 ? code.substring(4, 5) : ""),
                          buildCodeNumberBox(
                              code.length > 5 ? code.substring(5, 6) : ""),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Didn't recieve code? ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF818181),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Resend the code to the user");
                            },
                            child: Text(
                              "Request again",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          print("Verify and Create Account");
                          try {
                            await auth
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode,
                                        smsCode: code))
                                .then((value) async {
                              if (value.user != null) {
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => Home()),
                                //     (route) => false);
                                userController.phoneSetup(
                                    user: value.user,
                                    phoneNumber: widget.phone);
                              }
                            });
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                            _scaffoldkey.currentState.showSnackBar(
                                SnackBar(content: Text('invalid OTP')));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Verify and Create Account",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NumericPad(
              onNumberSelected: (value) {
                print(value);
                setState(() {
                  if (value != "-1") {
                    if (code.length < 6) {
                      code = code + value.toString();
                    }
                  } else {
                    code = code.substring(0, code.length - 1);
                  }
                  print(code);
                });
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.all(30.0),
            //   child: PinPut(
            //     fieldsCount: 6,
            //     textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
            //     eachFieldWidth: 40.0,
            //     eachFieldHeight: 55.0,
            //     focusNode: _pinPutFocusNode,
            //     controller: _pinPutController,
            //     submittedFieldDecoration: pinPutDecoration,
            //     selectedFieldDecoration: pinPutDecoration,
            //     followingFieldDecoration: pinPutDecoration,
            //     pinAnimationType: PinAnimationType.fade,
            //     onSubmit: (pin) async {
            //       try {
            //         await auth
            //             .signInWithCredential(PhoneAuthProvider.credential(
            //                 verificationId: _verificationCode, smsCode: pin))
            //             .then((value) async {
            //           if (value.user != null) {
            //             // Navigator.pushAndRemoveUntil(
            //             //     context,
            //             //     MaterialPageRoute(builder: (context) => Home()),
            //             //     (route) => false);
            //             userController.phoneSetup(
            //                 user: value.user, phoneNumber: widget.phone);
            //           }
            //         });
            //       } catch (e) {
            //         FocusScope.of(context).unfocus();
            //         _scaffoldkey.currentState
            //             .showSnackBar(SnackBar(content: Text('invalid OTP')));
            //       }
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  _verifyPhone() async {
    await auth.verifyPhoneNumber(
        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => Home()),
              //     (route) => false);
              userController.phoneSetup(
                  user: value.user, phoneNumber: widget.phone);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          print(_verificationCode);
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
