import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/colors.dart';
import 'package:faji_app/constants/images.dart';
import 'package:faji_app/models/postModel.dart';
import 'package:faji_app/views/dashboard/comment.dart';
import 'package:faji_app/views/dashboard/postVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

class postListView extends StatefulWidget {
  final String? position;
  final String? uid;

  postListView({Key? key, this.position, this.uid}) : super(key: key);

  @override
  _postListView createState() => _postListView();
}

class _postListView extends State<postListView> {
  bool liked = false;
  bool silent = false;
  bool isVideo = false;

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
        });
      });
    });
  }

  late DateTime timeCreate = DateTime.now();

  Future like(String postId, List likes) async {
    if (likes.contains(widget.uid)) {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([widget.uid.toString()])
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([widget.uid.toString()])
      });
    }
  }

  late ScrollController _scrollController = ScrollController(
      initialScrollOffset: double.parse(widget.position.toString()));

  @override
  void initState() {
    getPostList();
    print(widget.position.toString());
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // _scrollController.jumpTo(double.parse(widget.position.toString()));
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(profileBackground), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              IconButton(
                padding: EdgeInsets.only(left: 28, top: 32),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Iconsax.arrow_square_left, size: 28, color: black),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: 32 + 24 + 16, left: 16, right: 16, bottom: 16),
                  child: ListView.separated(
                      shrinkWrap: true,
                      controller: _scrollController,
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
                                      onTap: () {},
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
                                                color: black),
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
                                            like(postList[index].id,
                                                postList[index].likes);
                                          });
                                        },
                                        icon: (postList[index]
                                                .likes
                                                .contains(widget.uid))
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
                                                      uid:
                                                          widget.uid.toString(),
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
                                          color: black,
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
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
