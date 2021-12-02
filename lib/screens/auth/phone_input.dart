import 'package:flutter/material.dart';
import 'package:login_signup_screen/utils/colors.dart';

import 'otp_screen.dart';

class PhoneInput extends StatefulWidget {
  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  TextEditingController _controller = TextEditingController(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
            Container(
              margin: EdgeInsets.only(top: 60), 
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(),
                  hintText: 'Phone Number e.g +1',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.phone),
                  ),
                ),
                maxLength: 14,
                keyboardType: TextInputType.phone,
                controller: _controller,
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            width: double.infinity,
            // ignore: deprecated_member_use
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: kPrimaryColor,
              onPressed: () {
                print(_controller.text);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OTPScreen(_controller.text)));
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
