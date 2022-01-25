import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoder/geocoder.dart';
import 'package:login_signup_screen/controllers/feeds_controller.dart';
import 'package:login_signup_screen/controllers/user_controller.dart';
import 'package:login_signup_screen/screens/callscreens/pickup/pickup_layout.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/widgets/loading.dart';

import 'package:uuid/uuid.dart';

class UploadNoImage extends StatefulWidget {
  const UploadNoImage({Key key}) : super(key: key);

  @override
  _UploadNoImageState createState() => _UploadNoImageState();
}

class _UploadNoImageState extends State<UploadNoImage> {
  var _locationController;
  var _captionController;
  final _formKey = new GlobalKey<FormState>();
  FocusNode writingTextFocus = FocusNode();
  var uuid = Uuid();
  String uniquekey = "";
  bool isVideo = false;
  FeedsController _feedsController = Get.find();
  UserController _userController = Get.find();

  Address address;

  Map<String, double> currentLocation = Map();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
    //variables with location assigned as 0.0
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState(); //method to call location
  }

  //method to get Location and save into variables
  initPlatformState() async {
    Address first = await _feedsController.getUserLocation();
    setState(() {
      address = first;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    print("performing upload...with============= ");
    if (_validateAndSave()) {
      showLoading();
      writingTextFocus.unfocus();

      var postID = uuid.v4().toString();
      //String postImageURL;
      String imageName = "StarX_$uniquekey";
      print(imageName);

      try {
        await _feedsController.uploadPostInFirebase(
            paymentOption: _selectedOption,
            price: priceController.text.trim(),
            quantity: quantityController.text.trim(),
            type: "image",
            video: isVideo,
            imageName: imageName,
            postID: postID,
            caption: _captionController.text.trim(),
            ownerId: _userController.userData.value.uid,
            location: locationController.text.trim(),
            imgUrl: 'NONE');
        dismissLoading();
        Get.back();
        Get.back();
      } catch (e) {
        print('Error: $e');
        dismissLoading();
        Get.snackbar("Error!", "Error uploading post, try again ");
      }

      print("=======================>>>>>performing upload completed...");
      //Navigator.pop(context);
    }
    print("performing upload exited...");
    // setState(() {
    //   _isLoading = false;
    // });
  }

  final List<String> _paymentOption = [
    'Algo',
    'Fame',
    'USDC',
  ];

  String _selectedOption = "Algo";
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          title: Text('New Post', style: TextStyle(color: Colors.black)),
          backgroundColor: new Color(0xfff8faf8),
          elevation: 1.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 20.0),
              child: GestureDetector(
                child: Text('Share',
                    style: TextStyle(color: kPrimaryColor, fontSize: 16.0)),
                onTap: () {
                  // To show the CircularProgressIndicator
                  // _changeVisibility(false);
                  validateAndSubmit();
                },
              ),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8.0, top: 40),
                child: TextField(
                  controller: _captionController,
                  maxLines: 3,
                  focusNode: writingTextFocus,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                  ),
                  // onChanged: ((value) {
                  //   setState(() {
                  //     _captionController.text = value;
                  //   });
                  // }),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.pin_drop),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                        hintText: "Where was this photo taken?",
                        border: InputBorder.none),
                  ),
                ),
              ),
              Divider(), //scroll view where we will show location to users
              (address == null)
                  ? Container()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      child: Row(
                        children: <Widget>[
                          buildLocationButton(address.featureName),
                          buildLocationButton(address.subLocality),
                          buildLocationButton(address.locality),
                          buildLocationButton(address.subAdminArea),
                          buildLocationButton(address.adminArea),
                          buildLocationButton(address.countryName),
                        ],
                      ),
                    ),
              (address == null) ? Container() : Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Enter Product Quantity"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomInputFields(
                  controller: quantityController,
                  hint: " ",
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Enter Product Price"),
                  )),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomInputFields(
                  controller: priceController,
                  hint: " ",
                ),
              ),
              const SizedBox(height: 15),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Select Payment Method"),
                  )),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xffDFE2E5))),
                  width: size.width,
                  child: DropdownButton(
                    underline: Container(),
                    isExpanded: true,
                    hint: const Text(
                        'Selct Payment Option'), // Not necessary for Option 1
                    value: _selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption = newValue.toString();
                      });
                    },
                    items: _paymentOption.map((location) {
                      return DropdownMenuItem(
                        child: Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Offstage(
                  child: CircularProgressIndicator(),
                  offstage: _visibility,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //method to build buttons with location.
  buildLocationButton(String locationName) {
    if (locationName != null ?? locationName.isNotEmpty) {
      return InkWell(
        onTap: () {
          locationController.text = locationName;
        },
        child: Center(
          child: Container(
            //width: 100.0,
            height: 30.0,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(right: 3.0, left: 3.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                locationName,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}


class CustomInputFields extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const CustomInputFields(
      {Key key, @required this.controller, @required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        validator: (val) {
          return val.isEmpty ? "Field cannot be empty" : null;
        },

        // keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xffDFE2E5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xffDFE2E5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFF40A35),
            ),
          ),
        ),
      ),
    );
  }
}
