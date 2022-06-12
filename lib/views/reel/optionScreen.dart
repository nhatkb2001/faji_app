import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/colors.dart';
import 'package:faji_app/models/commentReelModel.dart';
import 'package:faji_app/models/reelModel.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/reel/commentReel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OptionScreen extends StatefulWidget {
  final String? uid;
  final String? reelId;
  OptionScreen({Key? key, this.uid, this.reelId}) : super(key: key);
  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  bool liked = false;
  String userId = '';
  Future like(String reelId, List likes) async {
    if (likes.contains(userId)) {
      FirebaseFirestore.instance.collection('reels').doc(reelId).update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      FirebaseFirestore.instance.collection('reels').doc(reelId).update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

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
        print(owner.avatar);
      });
    });
  }

  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .listen((value) {
      setState(() {
        user = userModel.fromDocument(value.docs.first.data());
        print(user.userName);
      });
    });
  }

  late reelModel reel = reelModel(
      id: '',
      idUser: '',
      caption: '',
      urlVideo: '',
      mode: '',
      timeCreate: '',
      state: '',
      ownerAvatar: '',
      likes: [],
      ownerUsername: '');

  Future getReelDetail() async {
    FirebaseFirestore.instance
        .collection("reels")
        .where("id", isEqualTo: widget.reelId)
        .snapshots()
        .listen((value) {
      setState(() {
        reel = reelModel.fromDocument(value.docs.first.data());
      });
    });
  }

  List<commentReelModel> listCMR = [];
  Future getNumbdercomment() async {
    FirebaseFirestore.instance
        .collection('reels')
        .doc(widget.reelId)
        .collection('comments')
        .snapshots()
        .listen((value) {
      value.docs.forEach((element) {
        setState(() {
          listCMR.add(commentReelModel.fromDocument(element.data()));
        });
      });
    });
  }

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    print(userId);
    getReelDetail();
    getOwnerDetail();
    getUserDetail();
    getNumbdercomment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          SizedBox(),
          Spacer(),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 56 + 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  (owner.avatar != '')
                                      ? owner.avatar
                                      : 'https://i.imgur.com/RUgPziD.jpg',
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                                alignment: Alignment.center,
                                child: Text(
                                  owner.userName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      color: white),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                          width: 283,
                          child: Text(
                            reel.caption,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                color: white),
                            maxLines: 1,
                          )),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: GestureDetector(
                                onTap: () {},
                                child: Icon(Iconsax.music_square5,
                                    color: white, size: 24)),
                          ),
                          SizedBox(width: 8),
                          Container(
                              alignment: Alignment.center,
                              width: 128,
                              child: Text(
                                'turmoilisme • Original sound',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    color: white),
                                maxLines: 1,
                              )),
                          SizedBox(width: 8),
                          Container(
                            child: GestureDetector(
                                onTap: () {},
                                child:
                                    Icon(Iconsax.map5, color: white, size: 24)),
                          ),
                          SizedBox(width: 8),
                          Container(
                              alignment: Alignment.center,
                              width: 90,
                              child: Text(
                                'Thu Duc city',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    color: white),
                                maxLines: 1,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(bottom: 56 + 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              liked = !liked;
                              print(' Like r ne');
                              print(liked);
                              like(reel.id, reel.likes);
                            });
                          },
                          icon: (reel.likes.contains(userId))
                              ? Container(
                                  padding: EdgeInsets.only(left: 16),
                                  alignment: Alignment.topRight,
                                  child: Icon(Iconsax.like_15,
                                      size: 24, color: pink),
                                )
                              : Container(
                                  padding: EdgeInsets.only(left: 16),
                                  alignment: Alignment.topRight,
                                  child: Icon(Iconsax.like_1,
                                      size: 24, color: white),
                                )),
                      Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          (reel.likes.isEmpty)
                              ? '0'
                              : reel.likes.length.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: "Urbanist",
                              fontSize: 24.0,
                              color: white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          atCommentReelScreen(
                                            required,
                                            uid: userId,
                                            reelId: reel.id,
                                          ))));
                            },
                            child: Icon(Iconsax.message_text,
                                color: white, size: 24)),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          listCMR.length.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: "Urbanist",
                              fontSize: 24.0,
                              color: white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        child: GestureDetector(
                            onTap: () {},
                            child:
                                Icon(Iconsax.send_2, color: white, size: 24)),
                      ),
                      SizedBox(height: 24),
                      Container(
                        child: GestureDetector(
                            onTap: () {},
                            child: Icon(Iconsax.more, color: white, size: 24)),
                      ),
                      SizedBox(height: 24),
                      Container(
                        child: GestureDetector(
                            onTap: () {},
                            child: Icon(Iconsax.voice_square,
                                color: white, size: 24)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
