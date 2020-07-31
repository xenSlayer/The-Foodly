import 'package:flutter/material.dart';
import 'package:foodly/components/appbar.dart';
import 'package:foodly/components/cachedImage/cachedImage.dart';
import 'package:foodly/constants/colors.dart';
import 'package:foodly/constants/icons.dart';
import 'package:foodly/constants/styles.dart';
import 'package:foodly/models/user.dart';
import 'package:foodly/resources/userRepository.dart';
import 'package:foodly/src/myAccount/profile/userDetail.dart';
import 'package:foodly/src/myAccount/profile/editProfile.dart';
import 'package:foodly/utilities/utils.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<UserRepository>().refreshUser();
    String name = context.watch<UserRepository>().getUser.name;
    String address = context.watch<UserRepository>().getUser.address;
    int contact = context.watch<UserRepository>().getUser.phoneNumber;
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: backIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profile",
          style: appTitleStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: bgCol,
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  context.watch<UserRepository>().getUser.profilePhoto != null
                      ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: mainCol,
                          ),
                          child: Stack(
                            overflow: Overflow.clip,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: CachedImage(
                                  context
                                      .watch<UserRepository>()
                                      .getUser
                                      .profilePhoto,
                                  isRound: true,
                                  radius: 100.0 - 2.0,
                                ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    // padding: EdgeInsets.only(left: 30.0),
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: secondCol,
                                    ),
                                    child: IconButton(
                                        icon: Icon(Icons.edit),
                                        tooltip: "CHANGE PROFILE",
                                        iconSize: 20,
                                        color: Colors.white,
                                        onPressed: () {
                                          User eUser = context
                                              .read<UserRepository>()
                                              .getUser;
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (_) {
                                            return EditProfile(
                                              eUser: eUser,
                                              // mode: 0,
                                            );
                                          }));
                                        }),
                                  )),
                            ],
                          ),
                        )
                      : Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: buttonCol,
                          ),
                          child: Center(
                            child: Text(
                              Utils.getInitials(
                                  context.watch<UserRepository>().getUser.name),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // color: UniversalVariables.lightBlueColor,
                                fontSize: 20,
                              ),
                            ),
                          )),
                  SizedBox(height: 15),
                  UserDetail(
                    name: name,
                    address: address,
                    contact: contact,
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  ListTile(
                    leading: IconButton(
                      tooltip: "LOG OUT",
                      icon: Icon(
                        LOGOUT_ICON,
                        // color: UniversalVariables.iconCol,
                      ),
                      onPressed: () async {
                        if (await Utils.confirmBox(context, "Log Out",
                            "Do you really want to log out?")) {
                          await context.read<UserRepository>().signOut();
                        }
                      },
                    ),
                    title: Text(
                      "Log Out",
                      // style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.only(left: 70.0),
                    onTap: () async {
                      if (await Utils.confirmBox(context, "Log Out",
                          "Do you really want to log out?")) {
                        await context.read<UserRepository>().signOut();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
