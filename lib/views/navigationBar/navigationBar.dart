import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/dashboard/dashboard.dart';
import 'package:faji_app/views/notification/notification.dart';
import 'package:faji_app/views/profile/profile.dart';
import 'package:faji_app/views/reel/reel.dart';
import 'package:faji_app/views/searching/searching.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:faji_app/constants/colors.dart';

class navigationBar extends StatefulWidget {
  String uid;

  navigationBar(required, {Key? key, required this.uid}) : super(key: key);
  @override
  _navigationBar createState() => _navigationBar(uid);
}

class _navigationBar extends State<navigationBar>
    with SingleTickerProviderStateMixin {
  String uid = "";

  _navigationBar(uid);
  TabController? _tabController;
  late userModel user = userModel(
      avatar: '',
      background: '',
      email: '',
      favoriteList: [],
      fullName: '',
      id: '',
      phoneNumber: '',
      saveList: [],
      state: '',
      userName: '',
      follow: [],
      role: '',
      gender: '',
      dob: '');

  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      setState(() {
        user = userModel.fromDocument(value.docs.first.data());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          atDashboardScreen(required, uid: uid),
          atSearchScreen(required, uid: uid),
          atReelScreen(required, uid: uid),
          atNotificationScreen(required, uid: uid),
          atProfileScreen(required, ownerId: uid)
        ],
        controller: _tabController,
        //onPageChanged: whenPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        height: 56,
        width: 375 + 24,
        // decoration: BoxDecoration(
        //   border: Border.all(color: white, width: 1),
        // ),
        // padding: EdgeInsets.only(
        //     left: (MediaQuery.of(context).size.width - 375 + 24) / 2,
        //     right: (MediaQuery.of(context).size.width - 375 + 24) / 2),
        child: ClipRRect(
          child: Container(
            color: blue,
            child: TabBar(
              labelColor: white,
              unselectedLabelColor: white,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: white, width: 1)),
              //For Indicator Show and Customization
              indicatorColor: black,
              tabs: <Widget>[
                Tab(
                    // icon: SvgPicture.asset(
                    //   nbDashboard,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.global, size: 24)),
                Tab(
                    // icon: SvgPicture.asset(
                    //   nbAccountManagement,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.search_normal, size: 24)),
                Tab(
                    // icon: SvgPicture.asset(
                    //   nbIncidentReport,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.video_play, size: 24)),
                Tab(
                    // icon: SvgPicture.asset(
                    //   nbIncidentReport,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.notification, size: 24)),
                Tab(
                  // icon: SvgPicture.asset(
                  //   nbIncidentReport,
                  //   height: 24, width: 24
                  // )
                  child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          (user.avatar == '')
                              ? 'https://i.imgur.com/RUgPziD.jpg'
                              : user.avatar,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}
