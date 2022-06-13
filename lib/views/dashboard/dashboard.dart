import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/images.dart';
import 'package:faji_app/models/postModel.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/dashboard/comment.dart';
import 'package:faji_app/views/dashboard/createPost.dart';
import 'package:faji_app/views/dashboard/createStory.dart';
import 'package:faji_app/views/dashboard/postVideo.dart';
import 'package:faji_app/views/message/messagesCenter.dart';
import 'package:faji_app/views/profile/profile.dart';
import 'package:faji_app/views/story/storyScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:intl/intl.dart';

///add constants
import 'package:faji_app/constants/colors.dart';
import 'package:video_player/video_player.dart';

class atDashboardScreen extends StatefulWidget {
  final String uid;
  atDashboardScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  _atDashboardScreen createState() => _atDashboardScreen(uid);
}

class _atDashboardScreen extends State<atDashboardScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atDashboardScreen(uid);

  bool liked = false;
  bool silent = false;
  bool isVideo = false;

  File? videoFile;

  File? imageFile;

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

  List videoList = [];
  List<postModel> postList = [];
  Future getPostList() async {
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        postList.clear();
        value.docs.forEach((element) {
          postList.add(postModel.fromDocument(element.data()));
          if (element.data()['urlVideo'] != '') {
            videoList.add(element.data()['urlVideo']);
            print("videoList");
            print(videoList);
          }
        });
      });
    });
  }

  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController =
      ChewieController(videoPlayerController: _videoPlayerController);
  bool check = false;
  bool play = false;

  Future<void> controlOnRefresh() async {
    setState(() {});
  }

  late DateTime timeCreate = DateTime.now();

  Future like(String postId, List likes, String ownerId) async {
    if (likes.contains(uid)) {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      }).whenComplete(() {
        if (uid != ownerId) {
          FirebaseFirestore.instance.collection('notifies').add({
            'idSender': uid,
            'idReceiver': ownerId,
            'avatarSender': user.avatar,
            'mode': 'public',
            'idPost': postId,
            'content': 'liked your photo',
            'category': 'like',
            'nameSender': user.userName,
            'timeCreate': "${DateFormat('hh:mm a').format(DateTime.now())}"
          }).then((value) {
            FirebaseFirestore.instance
                .collection('notifies')
                .doc(value.id)
                .update({'id': value.id});
          });
        }
      });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    getPostList();
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
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 32, right: 16, left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        user.userName,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: blue,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => atCreatePostScreen(
                                          required,
                                          uid: uid)),
                                );
                              },
                              child: AnimatedContainer(
                                alignment: Alignment.topRight,
                                duration: Duration(milliseconds: 300),
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    )),
                                child: Container(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.center,
                                    child: Icon(Iconsax.add,
                                        size: 16, color: black)),
                              ),
                            )),
                        SizedBox(width: 16),
                        Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        messsageScreen(required, uid: uid)),
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.topRight,
                                child: Icon(Iconsax.message,
                                    size: 24, color: black)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // SizedBox(height: 32),
              Container(
                  margin: EdgeInsets.only(top: 88, left: 16),
                  height: 78 + 24,
                  width: 375,
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(width: 16),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                            child: (index == 0)
                                ? Container(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                                width: 56,
                                                height: 56,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: blue,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8)))),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            atStoryScreen(
                                                              required,
                                                              uid: uid,
                                                            ))));
                                              },
                                              child: Container(
                                                width: 48,
                                                height: 48,
                                                margin: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          user.avatar),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 45, left: 45),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              atCreateStoryScreen(
                                                                required,
                                                                uid: uid,
                                                              ))));
                                                },
                                                child: Container(
                                                    width: 16,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16))),
                                                    child: Icon(Iconsax.add,
                                                        size: 14, color: gray)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Container(
                                            child: Text(
                                          'Your Story',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: black),
                                        ))
                                      ],
                                    ),
                                  )
                                : Container(
                                    // child:
                                    // Column(
                                    //   children: [
                                    //     Stack(
                                    //       children: [
                                    //         Container(
                                    //             width: 56,
                                    //             height: 56,
                                    //             decoration: BoxDecoration(
                                    //                 border: Border.all(
                                    //                   color: blue,
                                    //                   width: 1.5,
                                    //                 ),
                                    //                 borderRadius:
                                    //                     BorderRadius.all(
                                    //                         Radius.circular(
                                    //                             8)))),
                                    //         Container(
                                    //           padding: EdgeInsets.all(4),
                                    //           child: ClipRRect(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(4),
                                    //             child: Image.network(
                                    //               'https://i.imgur.com/eYOEUb7.jpg',
                                    //               width: 48,
                                    //               height: 48,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     SizedBox(height: 8),
                                    //     Container(
                                    //         child: Text(
                                    //       'Pan',
                                    //       style: TextStyle(
                                    //           fontSize: 12,
                                    //           fontFamily: 'Poppins',
                                    //           fontWeight: FontWeight.w500,
                                    //           color: black),
                                    //     ))
                                    //   ],
                                    // ),
                                    ));
                      })),
              Container(
                  margin: EdgeInsets.only(
                      top: 88 + 16 + 56 + 8 + 12,
                      left: 16,
                      right: 16,
                      bottom: 56),
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 16),
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    atProfileScreen(required,
                                                        ownerId: postList[index]
                                                            .idUser))));
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                postList[index].ownerAvatar,
                                                width: 32,
                                                height: 32,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                              child: Text(
                                            postList[index].ownerUsername,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                color: blue),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      alignment: Alignment.topRight,
                                      child: Icon(Iconsax.more,
                                          size: 24, color: black),
                                    )
                                  ],
                                ),
                              ),
                              (postList[index].urlImage != '')
                                  ? Container(
                                      width: 360,
                                      height: 340,
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 16),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          postList[index].urlImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : postVideoWidget(context,
                                      src: postList[index].urlVideo),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            liked = !liked;
                                            like(
                                                postList[index].id,
                                                postList[index].likes,
                                                postList[index].idUser);
                                          });
                                        },
                                        icon: (postList[index]
                                                .likes
                                                .contains(uid))
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                alignment: Alignment.topRight,
                                                child: Icon(Iconsax.like_15,
                                                    size: 24, color: pink),
                                              )
                                            : Container(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                alignment: Alignment.topRight,
                                                child: Icon(Iconsax.like_1,
                                                    size: 24, color: black),
                                              )),
                                    GestureDetector(
                                      onTap: () {
                                        //likes post
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (postList[index].likes.isEmpty)
                                                ? '0'
                                                : postList[index]
                                                    .likes
                                                    .length
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(left: 8),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    atCommentScreen(
                                                      required,
                                                      uid: uid,
                                                      postId:
                                                          postList[index].id,
                                                    ))));
                                      },
                                      icon: Container(
                                        child: Icon(Iconsax.message_text,
                                            size: 24, color: black),
                                      ),
                                    ),
                                    // Container(
                                    //     margin: EdgeInsets.only(left: 8),
                                    //     alignment: Alignment.centerLeft,
                                    //     child: Text(
                                    //       '24',
                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //         color: black,
                                    //         fontFamily: 'Poppins',
                                    //         fontWeight: FontWeight.w600,
                                    //       ),
                                    //     )),
                                    Spacer(),
                                    (isVideo)
                                        ? IconButton(
                                            onPressed: () {
                                              //save post
                                            },
                                            icon: (silent == true)
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Icon(
                                                        Iconsax.volume_slash,
                                                        size: 24,
                                                        color: gray),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Icon(
                                                        Iconsax.volume_high,
                                                        size: 24,
                                                        color: black),
                                                  ))
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent),
                                          )
                                  ],
                                ),
                              ),
                              // SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  //likes post
                                },
                                child: Container(
                                    width: 327 + 24,
                                    margin: EdgeInsets.only(left: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      postList[index].caption,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: blue,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    )),
                              ),
                              SizedBox(height: 8),
                              Container(
                                  margin: EdgeInsets.only(left: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    postList[index].timeCreate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: gray,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }))
            ],
          ),
        ));
  }
}
