import 'package:chewie/chewie.dart';
import 'package:faji_app/constants/colors.dart';
import 'package:faji_app/views/reel/likeDoubleTap.dart';
import 'package:faji_app/views/reel/optionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class followerWidget extends StatefulWidget {
  final String? src;
  final String? uid;
  final String? reelId;

  followerWidget({Key? key, this.src, this.uid, this.reelId}) : super(key: key);

  bool liked = false;
  @override
  _followerWidgetState createState() => _followerWidgetState();
}

class _followerWidgetState extends State<followerWidget> {
  @override
  void initState() {
    super.initState();
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
                  image: DecorationImage(image: NetworkImage(
                      // userList[index]
                      //     .avatar
                      'https://i.imgur.com/bCnExb4.jpg'), fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Peter",
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
