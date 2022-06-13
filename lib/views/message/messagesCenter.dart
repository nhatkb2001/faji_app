import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/images.dart';
import 'package:faji_app/models/commentModel.dart';
import 'package:faji_app/models/messageModel.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/message/messageDetail.dart';
import 'package:faji_app/views/notification/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

///add constants
import 'package:faji_app/constants/colors.dart';
import 'package:intl/intl.dart';

class messsageScreen extends StatefulWidget {
  String uid;
  messsageScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  _messsageScreenState createState() => _messsageScreenState(this.uid);
}

class _messsageScreenState extends State<messsageScreen> {
  String uid = '';
  _messsageScreenState(uid);

  List<userModel> userList = [];

  Future getAllUser() async {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      setState(() {
        userList.clear();
        value.docs.forEach((element) {
          userList.add(userModel.fromDocument(element.data()));
        });
        userList.forEach((element) {
          print(element.id);
          if (element.id == uid) {
            userList.remove(element);
          }
        });
        print(userList);
      });
    });
    setState(() {});
  }

  late userModel currentUser = userModel(
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
        currentUser = userModel.fromDocument(value.docs.first.data());
        print(currentUser.userName);
      });
    });
  }

  String newMessageId = "";
  String messageId = '';

  Future createMessage(String userName, String userIdS2, String userName2,
      String background2) async {
    FirebaseFirestore.instance.collection("messages").get().then((value) {
      value.docs.forEach((element) {
        if ((uid == (element.data()['userId1'] as String) &&
                    userIdS2 == (element.data()['userId2'] as String)) ||
                (uid == (element.data()['userId2'] as String) &&
                    userIdS2 == (element.data()['userId1'] as String))
            //      &&
            // element.data()['timeSend'] != null
            ) {
          newMessageId = element.id;
          print(newMessageId);
        }
      });
      setState(() {
        if (newMessageId == '') {
          FirebaseFirestore.instance.collection("messages").add({
            'userId1': uid,
            'userId2': userIdS2,
            'name1': "$userName",
            'name2': "$userName2",
            'background1': currentUser.avatar,
            'background2': background2,
            'contentList': FieldValue.arrayUnion([""]),
            'lastTimeSend': "${DateFormat('hh:mm a').format(DateTime.now())}",
            'lastMessage': '',
          }).then((value) {
            setState(() {
              FirebaseFirestore.instance
                  .collection("messages")
                  .doc(value.id)
                  .update({
                'messageId': value.id,
              });
            });
            messageId = value.id;
          });
        } else {
          (currentUser.id == userIdS2)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => messageDetailScreen(required,
                        uid: uid, uid2: userIdS2, messagesId: newMessageId),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => messageDetailScreen(required,
                        uid: userIdS2, uid2: uid, messagesId: newMessageId),
                  ),
                );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => messageDetailScreen(required,
          //         uid: uid, uid2: userIdS2, messagesId: newMessageId),
          //   ),
          // );
        }
      });
    });
  }

  late List<Message> messagesList = [];
  late List messagesIdList;
  Future getMessage() async {
    FirebaseFirestore.instance
        .collection("messages")
        .snapshots()
        .listen((value2) {
      setState(() {
        messagesList.clear();
        value2.docs.forEach((element) {
          if (uid.contains(element.data()['userId1'] as String) ||
              uid.contains(element.data()['userId2'] as String)) {
            messagesList.add(Message.fromDocument(element.data()));
          }
        });
      });
      print(messagesList.length);
    });
    setState(() {});
  }

  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    getAllUser();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileBackground), fit: BoxFit.cover),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 62),
                Container(
                  padding: EdgeInsets.only(right: 28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(left: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Iconsax.arrow_square_left,
                            size: 24, color: black),
                      ),
                      SizedBox(width: 6),
                      // Container(
                      //   padding: EdgeInsets.only(left: 16),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(4),
                      //     child: Image.network(
                      //       currentUser.avatar,
                      //       width: 48,
                      //       height: 48,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                currentUser.userName,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    color: blue,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2),
                              )),
                        ],
                      ),
                      Spacer(),
                      Container(
                          // padding: EdgeInsets.only(right: 28),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      atNotificationScreen(required, uid: uid),
                                ),
                              ).then((value) {});
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: black.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 64,
                                      offset: Offset(8, 8)),
                                  BoxShadow(
                                    color: black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Icon(Iconsax.notification,
                                      size: 18, color: white)),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.only(left: 28),
                  child: Text(
                    "Messages",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24.0,
                        color: blue,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 28),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         Screen(required, uid: uid),
                              //   ),
                              // );
                              // searchMessageDialog(context, userList);
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: Duration(milliseconds: 300),
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: Icon(Iconsax.search_normal,
                                      size: 18, color: black)),
                            ),
                          )),
                      SizedBox(width: 4),
                      Container(
                        width: 367,
                        height: 48,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: EdgeInsets.only(left: 4, right: 4),
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      createMessage(
                                          currentUser.userName,
                                          userList[index].id,
                                          userList[index].userName,
                                          userList[index].avatar);
                                      getMessage();
                                    },
                                    child: AnimatedContainer(
                                      alignment: Alignment.center,
                                      duration: Duration(milliseconds: 300),
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        width: 48,
                                        height: 48,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.network(
                                              userList[index].avatar,
                                              width: 32,
                                              height: 32,
                                            ),
                                          ),
                                        ),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ));
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Container(
                    padding: EdgeInsets.only(left: 28, right: 28),
                    height: 545,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36)),
                      color: white,
                    ),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 16),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              alignment: Alignment.center,
                              child: GestureDetector(
                                  onTap: () {
                                    (currentUser.id ==
                                            messagesList[index].userId2)
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  messageDetailScreen(
                                                      required,
                                                      uid:
                                                          messagesList[index]
                                                              .userId1,
                                                      uid2: messagesList[index]
                                                          .userId2,
                                                      messagesId:
                                                          messagesList[index]
                                                              .messageId),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  messageDetailScreen(
                                                      required,
                                                      uid:
                                                          messagesList[index]
                                                              .userId2,
                                                      uid2: messagesList[index]
                                                          .userId1,
                                                      messagesId:
                                                          messagesList[index]
                                                              .messageId),
                                            ),
                                          );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        width: 60,
                                        height: 60,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Image.network(
                                              (currentUser.id ==
                                                      messagesList[index]
                                                          .userId1)
                                                  ? messagesList[index]
                                                      .background2
                                                  : messagesList[index]
                                                      .background1,
                                              width: 32,
                                              height: 32,
                                            ),
                                          ),
                                        ),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 64,
                                        width: 232,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    (currentUser.id ==
                                                            messagesList[index]
                                                                .userId1)
                                                        ? messagesList[index]
                                                            .name2
                                                        : messagesList[index]
                                                            .name1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 14.0,
                                                        color: blue,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.4),
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  messagesList[index]
                                                      .lastTimeSend,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.0,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              width: 232,
                                              child: Text(
                                                messagesList[index].lastMessage,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 12.0,
                                                    color: black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            SizedBox(height: 6)
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          }),
                      SizedBox(height: 24)
                    ])))
              ],
            ),
          )
        ],
      ),
    );
  }
}
