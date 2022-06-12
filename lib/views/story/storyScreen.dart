import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/models/reelModel.dart';
import 'package:faji_app/models/storyModel.dart';
import 'package:faji_app/views/reel/contentScreen.dart';
import 'package:faji_app/views/reel/createReel.dart';
import 'package:faji_app/views/story/contentStory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///add constants
import 'package:faji_app/constants/colors.dart';
import 'package:video_player/video_player.dart';

class atStoryScreen extends StatefulWidget {
  String uid;
  atStoryScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  _atStoryScreen createState() => _atStoryScreen();
}

class _atStoryScreen extends State<atStoryScreen>
    with SingleTickerProviderStateMixin {
  String userId = '';

  List<storyModel> storiesList = [];
  List videoList = [];
  List imageList = [];
  List ownerId = [];
  List storiesId = [];
  Future getstoriesList() async {
    FirebaseFirestore.instance
        .collection("stories")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        storiesList.clear();
        videoList.clear();
        ownerId.clear();
        value.docs.forEach((element) {
          storiesList.add(storyModel.fromDocument(element.data()));
          if (element.data()['urlVideo'] != '') {
            videoList.add(element.data()['urlVideo']);
            print("videoList");
            print(videoList);
          }
          ownerId.add(element.data()['userId']);
          storiesId.add(element.data()['id']);
        });
        print("videoList");
        print(videoList);
      });
    });
  }

  late SwiperController swiperController;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    print(userId);
    getstoriesList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ContentStoryScreen(
            src: videoList[index],
            uid: ownerId[index],
            storyId: storiesId[index],
          );
        },
        itemCount: videoList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
