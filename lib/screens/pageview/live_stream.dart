import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:login_signup_screen/constants/asset_path.dart';
import 'package:login_signup_screen/controllers/user_controller.dart';
import 'package:login_signup_screen/screens/callscreens/pickup/pickup_layout.dart';
import 'package:login_signup_screen/screens/feeds/LiveStream/stream.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/utils/permissions.dart';
import 'package:login_signup_screen/utils/text_styles.dart';
import 'package:login_signup_screen/widgets/cached_image.dart';
import 'package:login_signup_screen/widgets/custom_text.dart';

class LiveStreamPage extends StatelessWidget {
  final UserController _userController = Get.find();

  Widget startBroadcast(context) => GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (context) {
              return CreateBroadCast();
            }),
        child: Container(
          height: 250,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(4, 8),
                  blurRadius: 2,
                  spreadRadius: 1,
                  color: Colors.grey[200],
                )
              ]
              // gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [
              //     Color(0xff3AC2F8),
              //     Color(0xff75D4FA),
              //   ],
              // ),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Live Broadcast",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Create Live Video Streaming",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "Start Streaming",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  Widget rowContainer({IconData icon, String text, Function onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150,
          width: 100,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 4),
                blurRadius: 2,
                spreadRadius: 1,
                color: Colors.grey[200],
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(height: 15),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    var WIDTH = MediaQuery.of(context).size.width;
    var HEIGHT = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;
    return PickupLayout(
      scaffold: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          text:
                              "Hi, ${_userController.userData.value.username}",
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                        CachedImage(
                          //pass to profile of the receiver
                          _userController.userData.value.profilePhoto,
                          radius: 50,
                          isRound: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    startBroadcast(context),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            width: size.width * 0.40,
                            child: rowContainer(
                              icon: Entypo.video_camera,
                              text: "Join Stream",
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return JoinBroadCast();
                                  }),
                            )),
                        SizedBox(
                            width: size.width * 0.40,
                            child: rowContainer(
                                icon: Entypo.calendar,
                                text: "Schedule Live Stream",
                                onTap: () => Get.snackbar(
                                      "Notice!",
                                      "Functionality coming soon",
                                    ))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBroadCast extends StatelessWidget {
  TextEditingController channelName = TextEditingController();
  String check = '';
  bool _isBroadcaster = true;
  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Create Live Stream", style: TextStyle(color: Colors.black)),
      content: Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            stream,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: channelName,
            decoration: InputDecoration(
                hintText: "Create Access Key",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2))),
            style: regularTxtStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          // ignore: deprecated_member_use
          FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: kPrimaryColor,
            onPressed: () async {
              if (channelName.text.isNotEmpty) {
                bool isPermissionGranted =
                    await Permissions.cameraAndMicrophonePermissionsGranted();
                if (isPermissionGranted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BroadcastPage(
                        userName: _userController.userData.value.username,
                        channelName: channelName.text.trim(),
                        isBroadcaster: _isBroadcaster,
                      ),
                    ),
                  );
                } else {
                  Get.snackbar("Failed", "Enter Broadcast key.",
                      backgroundColor: Colors.white,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM);
                }
              } else {
                Get.snackbar(
                    "Failed", "Microphone Permission Required for Video Call.",
                    backgroundColor: Colors.white,
                    colorText: Colors.blue,
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(
                  width: 20,
                ),
                Text("Start BroadCast",
                    style: regularTxtStyle.copyWith(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JoinBroadCast extends StatelessWidget {
  TextEditingController channelName = TextEditingController();
  String check = '';
  bool _isBroadcaster = false;
  UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Join Live Stream", style: TextStyle(color: Colors.black)),
      content: Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            join,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: channelName,
            decoration: InputDecoration(
                hintText: "Enter Broadcast Key",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2))),
            style: regularTxtStyle.copyWith(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          // ignore: deprecated_member_use
          FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            color: kPrimaryColor,
            onPressed: () async {
              if (channelName.text.isNotEmpty) {
                bool isPermissionGranted =
                    await Permissions.cameraAndMicrophonePermissionsGranted();
                if (isPermissionGranted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BroadcastPage(
                        userName: _userController.userData.value.username,
                        channelName: channelName.text.trim(),
                        isBroadcaster: _isBroadcaster,
                      ),
                    ),
                  );
                } else {
                  Get.snackbar("Failed", "Enter Broadcast-Id to Join.",
                      backgroundColor: Colors.white,
                      colorText: Colors.blue,
                      snackPosition: SnackPosition.BOTTOM);
                }
              } else {
                Get.snackbar(
                    "Failed", "Microphone Permission Required for Video Call.",
                    backgroundColor: Colors.white,
                    colorText: Colors.blue,
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(
                  width: 20,
                ),
                Text("Join BroadCast",
                    style: regularTxtStyle.copyWith(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
