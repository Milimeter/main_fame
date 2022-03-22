import 'package:flutter/material.dart';
import 'package:login_signup_screen/model/user_data.dart';

import 'components/app_bar.dart';
import 'components/profile_widget.dart';

class ChatUserProfile extends StatefulWidget {
  final UserData receiver;

  const ChatUserProfile({Key key, @required this.receiver}) : super(key: key);
  @override
  _ChatUserProfileState createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: widget.receiver.profilePhoto?? "",
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(name: widget.receiver.name ?? "Not Added", email: widget.receiver.email?? "Not Added"),
          const SizedBox(height: 24),
          // Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          //NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(about: widget.receiver.bio?? "Not Added", status: widget.receiver.status),
        ],
      ),
    );
  
  }

  Widget buildName({String name, String email}) => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'Upgrade To PRO',
  //       onClicked: () {},
  //     );

  Widget buildAbout({String about, String status}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              about.length ==0 ?  " This user has no bio information": about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            Text(
              'Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              status.length ==0 ?  " Unable to get user status info": status,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
