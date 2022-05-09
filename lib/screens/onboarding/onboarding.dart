import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:login_signup_screen/screens/auth/login.dart';
import 'package:login_signup_screen/screens/auth/signup.dart';
import 'package:login_signup_screen/screens/onboarding/content_model.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/widgets/custom_text.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  PageController _controller;
  final box = GetStorage();

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/afarm.jpeg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: CText(
                                text: "Welcome to FAME",
                                fontWeight: FontWeight.w600,
                                size: 25,
                                color: kWhiteColor,
                                bold: true,
                                fontFamily: "AvenirNext-Bold",
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: CText(
                                text:
                                    "Create your gallery of products and transact easily in \$ALGO and \$FAME",
                                color: kWhiteColor,
                                fontWeight: FontWeight.w600,
                                size: 14,
                                textAlign: TextAlign.start,
                                fontFamily: "AvenirNext-UltraLight",
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.04),
                            GestureDetector(
                              onTap: () async {
                                // await Storage.setStep("login");
                                // Get.offAllNamed(Routes.LOGIN);
                                box.write("FreshInstall", false);
                                Get.to(() => LoginPage());
                              },
                              child: Container(
                                height: 60,
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Center(
                                  child: CText(
                                    text: "Sign in",
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w600,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            GestureDetector(
                              onTap: () async {
                                // await Storage.setStep("sign_up");
                                // Get.offAllNamed(Routes.SIGN_UP);
                                box.write("FreshInstall", false);
                                Get.to(() => SignupPage());
                              },
                              child: Container(
                                height: 60,
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kWhiteColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Center(
                                  child: CText(
                                    text: "Create an account",
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w600,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       Expanded(
    //         child: PageView.builder(
    //           controller: _controller,
    //           itemCount: contents.length,
    //           onPageChanged: (int index) {
    //             setState(() {
    //               currentIndex = index;
    //             });
    //           },
    //           itemBuilder: (_, i) {
    //             return Padding(
    //               padding: const EdgeInsets.all(40),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   SizedBox(
    //                     height: 250,
    //                     child: Image.asset(
    //                       contents[i].image,
    //                       fit: BoxFit.cover,
    //                       //height: 500,
    //                     ),
    //                   ),
    // Text(
    //   contents[i].title,
    //   textAlign: TextAlign.center,
    //   style: TextStyle(
    //     fontSize: 25,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    //                   SizedBox(height: 20),
    // Text(
    //   contents[i].discription,
    //   textAlign: TextAlign.center,
    //   style: TextStyle(
    //     fontSize: 18,
    //     color: Colors.grey,
    //   ),
    // )
    //                 ],
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //       Container(
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: List.generate(
    //             contents.length,
    //             (index) => buildDot(index, context),
    //           ),
    //         ),
    //       ),
    //       Container(
    //         height: 60,
    //         margin: EdgeInsets.all(40),
    //         width: double.infinity,
    //         // ignore: deprecated_member_use
    //         child: FlatButton(
    //           child: Text(
    //               currentIndex == contents.length - 1 ? "Continue" : "Next"),
    //           onPressed: () {
    //             if (currentIndex == contents.length - 1) {
    //               box.write("FreshInstall", false);
    //               Navigator.pushReplacement(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (_) => LoginPage(),
    //                 ),
    //               );
    //             }
    //             _controller.nextPage(
    //               duration: Duration(milliseconds: 100),
    //               curve: Curves.bounceIn,
    //             );
    //           },
    //           color: Theme.of(context).primaryColor,
    //           textColor: Colors.white,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
