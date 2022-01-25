import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:login_signup_screen/constants/controllers.dart';
import 'package:login_signup_screen/methods/local_db/repository/log_repository.dart';
import 'package:login_signup_screen/screens/chat_screen/chat.dart';
import 'package:login_signup_screen/screens/feeds/feeds.dart';
import 'package:login_signup_screen/screens/pageview/algorand_web.dart';
import 'package:login_signup_screen/screens/pageview/developer_settings.dart';
import 'package:login_signup_screen/utils/colors.dart';

import 'pageview/live_stream.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  HomeScreen({this.index});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Feeds(),
    ChatListScreen(),
    LiveStreamPage(),
    AlgoWeb(),
    DeveloperSettings(),
  ];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      LogRepository.init(
        isHive: true,
        dbName: userController.userData.value.uid,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions
          .elementAt(widget.index == null ? selectedIndex : widget.index),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300],
              hoverColor: Colors.grey[100],
              gap: 8,
              activeColor: kPrimaryColor,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100],
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Entypo.news,
                  text: 'Home',
                  iconColor: kPrimaryColor,
                ),
                GButton(
                  icon: Entypo.chat,
                  text: 'Chat',
                  iconColor: kPrimaryColor,
                ),
                GButton(
                  icon: Entypo.flickr_with_circle,
                  text: 'Stream',
                  iconColor: kPrimaryColor,
                ),
                GButton(
                  icon: Entypo.qq,
                  text: 'Solutions',
                  iconColor: kPrimaryColor,
                ),
                GButton(
                  icon: Entypo.user,
                  text: 'Profile',
                  iconColor: kPrimaryColor,
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
