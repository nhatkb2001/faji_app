import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/constants/images.dart';
import 'package:ferce_app/models/commentModel.dart';
import 'package:ferce_app/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

///add constants
import 'package:ferce_app/constants/colors.dart';
import 'package:intl/intl.dart';

class atCommentScreen extends StatefulWidget {
  String uid;
  String postId;
  atCommentScreen(required, {Key? key, required this.uid, required this.postId})
      : super(key: key);

  @override
  _atCommentScreen createState() => _atCommentScreen(uid, postId);
}

class _atCommentScreen extends State<atCommentScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  String postId = '';
  _atCommentScreen(this.uid, this.postId);

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
        print(user.userName);
      });
    });
  }

  TextEditingController commentController = TextEditingController();
  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();

  List<commentModel> commentList = [];

  Future getCommentList() async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((value) {
      setState(() {
        commentList.clear();
        value.docs.forEach((element) {
          commentList.add(commentModel.fromDocument(element.data()));
        });
      });
    });
  }

  Future comment(String postId) async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'userId': uid,
      'ownerUsername': user.userName,
      'ownerAvatar': user.avatar,
      'postId': postId,
      'content': commentController.text,
      'state': 'show',
      'time': DateFormat('yMMMMd').format(DateTime.now()).toString()
    }).then((value) => FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(value.id)
            .update({'id': value.id}));
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    print('Day la :' + postId);
    getCommentList();
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
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Container(
                      margin:
                          EdgeInsets.only(left: 24, right: 24, top: 20 + 20),
                      child: Column(children: [
                        Row(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Iconsax.back_square, size: 28),
                          ),
                          SizedBox(width: 32),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Comment',
                              style: TextStyle(
                                  fontFamily: 'Recoleta',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ),
                        ]),
                        SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Container(
                                height: 640,
                                child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(height: 0),
                                    itemCount: commentList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(4),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Image.network(
                                                        commentList[index]
                                                            .ownerAvatar,
                                                        width: 32,
                                                        height: 32,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Container(
                                                      child: Text(
                                                    commentList[index]
                                                        .ownerUsername,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: black),
                                                  ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 327 + 24),
                                                margin: EdgeInsets.only(
                                                    top: 16,
                                                    left: 8,
                                                    bottom: 16,
                                                    right: 24),
                                                // height: 73,
                                                // width: 236 - 12,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(16.0),
                                                  ),
                                                  color: Colors.transparent,
                                                ),
                                                child: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text: commentList[index]
                                                        .content,
                                                    style: TextStyle(
                                                        fontFamily: "Urbanist",
                                                        fontSize: 16.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ]))),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              alignment: Alignment.topRight,
                                              child: Icon(Iconsax.like_15,
                                                  size: 16, color: black),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(height: 24),
                              Container(
                                height: 54,
                                padding: EdgeInsets.only(left: 24, right: 24),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  color: gray,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    // SizedBox(width: 16),
                                    Container(
                                      width: 241,
                                      child: Expanded(
                                          child: Form(
                                        key: commentFormKey,
                                        child: TextField(
                                            controller: commentController,
                                            // onChanged: (value) => setState(() {
                                            //       comment = value;
                                            //     }),
                                            onEditingComplete: () {
                                              setState(() {
                                                commentController.clear();
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 14,
                                                color: black,
                                              ),
                                              hintText: "Type your comment...",
                                            )),
                                      )),
                                    ),
                                    Spacer(),
                                    Container(
                                        margin: EdgeInsets.only(right: 8),
                                        // padding: EdgeInsets.zero,
                                        alignment: Alignment.center,
                                        child: IconButton(
                                            icon: Icon(Iconsax.send1),
                                            iconSize: 24,
                                            color: white,
                                            onPressed: () {
                                              setState(() {
                                                comment(postId);
                                                commentController.clear();
                                              });
                                              setState(() {});
                                            })),
                                  ],
                                ),
                              ),
                            ]))
                      ]))))
        ])));
    // ])));
  }
}
