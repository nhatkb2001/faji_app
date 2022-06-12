import 'package:chewie/chewie.dart';
import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/views/profile/postListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class ImageWidget extends StatefulWidget {
  final String? src;
  final String? postId;
  final String? uid;
  final String? position;

  ImageWidget({Key? key, this.src, this.postId, this.uid, this.position})
      : super(key: key);

  @override
  _ImageWidget createState() => _ImageWidget();
}

class _ImageWidget extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => postListView(
                      position: widget.position, uid: widget.uid)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.src.toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
