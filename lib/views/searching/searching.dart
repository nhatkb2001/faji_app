import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/images.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/profile/profile.dart';
import 'package:faji_app/views/searching/classifyImage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///add constants
import 'package:faji_app/constants/colors.dart';
import 'package:tflite/tflite.dart';

class atSearchScreen extends StatefulWidget {
  String uid;
  atSearchScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  _atSearchScreen createState() => _atSearchScreen(uid);
}

class _atSearchScreen extends State<atSearchScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atSearchScreen(this.uid);
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String search = '';
  List<userModel> userList = [];
  Future searchUserName() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userName", isGreaterThanOrEqualTo: search)
        .snapshots()
        .listen((value) {
      setState(() {
        userList.clear();
        value.docs.forEach((element) {
          userList.add(userModel.fromDocument(element.data()));
        });
        print(userList.length);
      });
    });
  }

  File? imageFile;
  String link = '';

  late String urlImage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
            body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileBackground), fit: BoxFit.cover),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 32, right: 16, left: 16),
            child: Column(
              children: [
                SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  child: Form(
                    // key: formKey,
                    child: Container(
                      width: 327 + 24,
                      height: 40,
                      padding: EdgeInsets.only(left: 2, right: 24),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), color: white),
                      alignment: Alignment.topCenter,
                      child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 14,
                              color: black,
                              fontWeight: FontWeight.w400),
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            search = val;
                            searchUserName();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              atClassifyImageScreen()));
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Iconsax.camera,
                                          size: 20, color: black)
                                    ])),
                            prefixIcon: Container(
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                  Icon(Iconsax.search_normal_1,
                                      size: 20, color: black)
                                ])),
                            border: InputBorder.none,
                            hintText: "What are you looking for?",
                            hintStyle: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                color: gray,
                                fontWeight: FontWeight.w400),
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 16),
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => atProfileScreen(
                                            required,
                                            ownerId: userList[index].id)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        userList[index].avatar,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                      child: Text(
                                    userList[index].userName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                        color: black),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            ),
          )
        ])));
  }
}
