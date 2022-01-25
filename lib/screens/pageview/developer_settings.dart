import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:login_signup_screen/constants/controllers.dart';
import 'package:login_signup_screen/screens/algo_ui/send_payment.dart';
import 'package:login_signup_screen/screens/callscreens/pickup/pickup_layout.dart';
import 'package:login_signup_screen/screens/control/algorand_setup.dart';
import 'package:login_signup_screen/screens/feeds/profile_screen.dart';
import 'package:login_signup_screen/screens/profile/edit_profile.dart';
import 'package:login_signup_screen/screens/profile/web.dart';
import 'package:login_signup_screen/utils/colors.dart';
import 'package:login_signup_screen/widgets/algo_transact_widget.dart';

class DeveloperSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("----${userController.userData.value.email}");
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Settings"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card
              GestureDetector(
                onTap: () {
                  Get.to(ProfileScreen());
                },
                child: BigUserCard(
                  cardColor: Colors.red,
                  userName: userController.userData.value.name.toString(),
                  userProfilePic: NetworkImage(
                      userController.userData.value.profilePhoto ??
                          "https://placeholder.com/300.png"),
                  userMoreInfo: Row(
                    children: [
                      Expanded(
                        child: Text(
                            userController.userData.value.publicAddress.isEmpty
                                ? "Setup your wallet below"
                                : userController.userData.value.publicAddress,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      userController.userData.value.publicAddress.isEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.railway_alert,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                // ClipboardData data = ClipboardData(
                                //     text: userController
                                //         .userData.value.publicAddress
                                //         .toString());
                                // await Clipboard.setData(data);
                              })
                          : IconButton(
                              icon: Icon(
                                Entypo.copy,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                ClipboardData data = ClipboardData(
                                    text: userController
                                        .userData.value.publicAddress
                                        .toString());
                                await Clipboard.setData(data);
                              }),
                    ],
                  ),
                  cardActionWidget: SettingsItem(
                    icons: Icons.edit,
                    iconStyle: IconStyle(
                      withBackground: true,
                      borderRadius: 50,
                      backgroundColor: Colors.yellow[600],
                    ),
                    title: "Modify",
                    subtitle: "Tap to change your data",
                    onTap: () {
                      Get.to(EditProfilePage());
                    },
                  ),
                ),
              ),

              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Get.to(AlgorandSetup());
                    },
                    icons: Entypo.new_icon,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Alert',
                    subtitle: "Alert nearby farmers of an emergency",
                  ),
                  SettingsItem(
                    onTap: () {
                      Get.to(Web(url: "https://jaysource-35af0.web.app/"));
                    },
                    icons: Entypo.swarm,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: kPrimaryColor,
                    ),
                    title: 'FAME/DEX',
                    subtitle: "Fame/Dex blockcain applications",
                  ),
                  userController.userData.value.publicAddress.isEmpty
                      ? SettingsItem(
                          onTap: () {
                            Get.to(AlgorandSetup());
                          },
                          icons: Entypo.line_graph,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: kPrimaryColor,
                          ),
                          title: 'Algorand',
                          subtitle: "Setup your Algorand Wallet",
                        )
                      : SettingsItem(
                          onTap: () {
                            algoSendDialog(context,
                                uid: userController.userData.value.uid);
                          },
                          icons: FontAwesomeIcons.barcode,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: kPrimaryColor,
                          ),
                          title: 'Receive Algo',
                          subtitle: "Add more Algorand to your wallet",
                        ),
                  SettingsItem(
                    onTap: () {
                      Get.to(AlgorandSetup());
                    },
                    icons: Entypo.creative_commons_public_domain,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: kPrimaryColor,
                    ),
                    title: 'FAME',
                    subtitle: "Setup your Fame Wallet",
                  ),
                  // userController.userData.value.publicAddress.isNotEmpty
                  //     ? SettingsItem(
                  //         onTap: () {
                  //           Get.to(Scanner());
                  //         },
                  //         icons: Entypo.share,
                  //         iconStyle: IconStyle(
                  //           iconsColor: Colors.white,
                  //           withBackground: true,
                  //           backgroundColor: kPrimaryColor,
                  //         ),
                  //         title: 'Pay',
                  //         subtitle: "Send Algorand to your friends",
                  //       )
                  //     : SettingsItem(
                  //         onTap: () {},
                  //         icons: Entypo.share,
                  //         iconStyle: IconStyle(),
                  //         title: 'Pay',
                  //         subtitle: "Send Algorand to your friends",
                  //       ),
                  SettingsItem(
                    onTap: () {
                      Get.to(() => const SendAlgoPayment());
                    },
                    icons: Feather.credit_card,
                    iconStyle: IconStyle(
                      withBackground: true,
                      backgroundColor: kPrimaryColor,
                    ),
                    title: 'Send Payment',
                    subtitle: "Send Algorand to your friends",
                  ),
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: Icons.fingerprint,
                  //   iconStyle: IconStyle(
                  //     iconsColor: Colors.white,
                  //     withBackground: true,
                  //     backgroundColor: Colors.red,
                  //   ),
                  //   title: 'Privacy',
                  //   subtitle: "Lock FameFarm to improve your privacy",
                  // ),
                  // SettingsItem(
                  //   onTap: () {},
                  //   icons: Icons.dark_mode_rounded,
                  //   iconStyle: IconStyle(
                  //     iconsColor: Colors.white,
                  //     withBackground: true,
                  //     backgroundColor: Colors.red,
                  //   ),
                  //   title: 'Dark mode',
                  //   subtitle: "Automatic",
                  //   trailing: Switch.adaptive(
                  //     value: false,
                  //     onChanged: (value) {},
                  //   ),
                  // ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {
                      Get.to(Web(url: "https://www.algofame.org"));
                    },
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: 'About',
                    subtitle: "Learn more about us",
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () {
                      userController.signOut();
                    },
                    icons: Icons.exit_to_app_rounded,
                    title: "Sign Out",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.repeat,
                    title: "Change email",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
