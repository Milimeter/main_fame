import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_signup_screen/constants/firebase.dart';
import 'package:login_signup_screen/utils/colors.dart';

const kDefaultPadding = EdgeInsets.symmetric(horizontal: 30);

TextStyle titleText =
    TextStyle(color: kPrimaryColor, fontSize: 32, fontWeight: FontWeight.w700);
TextStyle subTitle = TextStyle(
    color: kSecondaryColor, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle textButton = TextStyle(
  color: kPrimaryColor,
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController resetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
            ),
            Text(
              'Reset Password',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Please enter your email address',
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: resetController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[200]),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor))),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () {
                  if (!(resetController.text.length < 7)) {
                    auth
                        .sendPasswordResetEmail(email: resetController.text)
                        .then((value) {
                      Get.snackbar("Success",
                          "An Email has been sent to you to reset your password");
                    });
                  } else {
                    Get.snackbar("Error", "Invalid Email address");
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => LogInScreen(),
                  //     ));
                },
                child: PrimaryButton(buttonText: 'Reset Password')),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  PrimaryButton({@required this.buttonText});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: kPrimaryColor),
      child: Text(
        buttonText,
        style: textButton.copyWith(color: Colors.white),
      ),
    );
  }
}
