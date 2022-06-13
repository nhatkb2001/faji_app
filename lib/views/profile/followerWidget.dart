import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/colors.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/reel/likeDoubleTap.dart';
import 'package:faji_app/views/reel/optionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class followerWidget extends StatefulWidget {
  final String? uid;

  followerWidget({Key? key, this.uid}) : super(key: key);

  bool liked = false;
  @override
  _followerWidgetState createState() => _followerWidgetState();
}

class _followerWidgetState extends State<followerWidget> {
  late userModel owner = userModel(
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
  Future getOwnerDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: widget.uid)
        .snapshots()
        .listen((value) {
      setState(() {
        owner = userModel.fromDocument(value.docs.first.data());
        print(owner.userName);
        print("owner.background");
        print(owner.background);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOwnerDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _liked = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 0, right: 16),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          // userList[index]
                          //     .avatar
                          (owner.avatar != '')
                              ? owner.avatar
                              : 'https://i.imgur.com/RUgPziD.jpg'),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 8),
              Text(
                owner.userName,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
