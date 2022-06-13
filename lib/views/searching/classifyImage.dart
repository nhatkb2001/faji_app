import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faji_app/constants/images.dart';
import 'package:faji_app/models/postModel.dart';
import 'package:faji_app/models/userModel.dart';
import 'package:faji_app/views/dashboard/postVideo.dart';
import 'package:faji_app/views/profile/image.dart';
import 'package:faji_app/views/profile/profile.dart';
import 'package:faji_app/views/profile/video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:intl/intl.dart';

///add constants
import 'package:faji_app/constants/colors.dart';
import 'package:tflite/tflite.dart';

class atClassifyImageScreen extends StatefulWidget {
  String uid;
  atClassifyImageScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _atClassifyImageScreen createState() => _atClassifyImageScreen(this.uid);
}

class _atClassifyImageScreen extends State<atClassifyImageScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atClassifyImageScreen(this.uid);
  String imageFile = '';
  String link = '';

  TextEditingController captionController = TextEditingController();
  final GlobalKey<FormState> captionFormKey = GlobalKey<FormState>();

  List<postModel> postList = [];
  List<postModel> postListCaption = [];
  Future searchUserName() async {
    FirebaseFirestore.instance.collection("posts").snapshots().listen((value) {
      setState(() {
        postListCaption.clear();
        postList.clear();
        value.docs.forEach((element) {
          postListCaption.add(postModel.fromDocument(element.data()));
        });

        postListCaption.forEach((element) {
          print(
              (element.caption.toUpperCase().contains(search.toUpperCase())) ==
                  true);
          if (((element.caption + " ")
                  .toUpperCase()
                  .contains(search.toUpperCase())) ==
              true) {
            postList.add(element);
            print(postList.length);
          }
        });
        if (postList.isEmpty) {
          setState(() {
            resultError = 'PLease choose an image regarding to clothes!';
          });
        }
      });
    });
  }

  handleTakePhoto() async {
    Navigator.pop(context);
  }

  String search = '';
  String resultError = '';

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
            model: "assets/model.tflite", labels: "assets/labels.txt")
        .onError((error, stackTrace) {
      resultError = 'PLease choose another image';
      return null;
    }))!;

    print("Models loading status: $res");
  }

  List _results = [];
  Future handleTakeGallery() async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowCompression: false,
    );
    print('result');
    print(result);
    if (result != null) {
      // Upload file
      print(result.files.first.name);
      print(result.files.first.path);
      if (result.files.first.path != null) {
        print(result.files.first.path.toString());
        final List? recognitions = await Tflite.runModelOnImage(
          path: result.files.first.path.toString(),
          numResults: 1,
          threshold: 0.05,
          imageMean: 127.5,
          imageStd: 127.5,
        );
        setState(() {
          imageFile = result.files.first.path.toString();
          _results = recognitions!;
        });
      }
    }
  }

  selectImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Choose Resource",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: black),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text(
                  "Photo with Gallery",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: handleTakeGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    loadModel();
  }

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
            color: white,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Container(
                      margin:
                          EdgeInsets.only(left: 24, right: 24, top: 20 + 20),
                      child: Column(children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Iconsax.back_square, size: 28),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                searchUserName();
                              },
                              child: Icon(Iconsax.search_favorite, size: 28),
                            )
                          ],
                        ),
                        SizedBox(height: 24),
                        Container(
                            // margin: EdgeInsets.only(
                            //     left: 24, right: 24, top: 20 + 20),
                            child: Column(children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Classify',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 192,
                              height: 0.5,
                              decoration: BoxDecoration(
                                color: gray,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 144,
                              height: 0.5,
                              decoration: BoxDecoration(
                                color: gray,
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              (imageFile != '')
                                  ? Container(
                                      width: 360,
                                      height: 340,
                                      padding:
                                          EdgeInsets.only(top: 24, bottom: 16),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.file(
                                          File(imageFile),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(24),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: gray, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Colors.transparent),
                                        child: IconButton(
                                            icon: Icon(Iconsax.add,
                                                size: 30, color: gray),
                                            onPressed: () =>
                                                selectImage(context)),
                                      ),
                                    )
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Classify: ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 16),
                          (_results.isEmpty)
                              ? Container()
                              : SingleChildScrollView(
                                  child: Column(
                                    children: _results.map((result) {
                                      setState(() {
                                        search = "${result['label']} ";
                                      });
                                      return Card(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text("${result['label']} ",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: black,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          SizedBox(height: 24),
                          Container(
                            width: 327 + 24,
                            height: 400,
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: GridView.custom(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              gridDelegate: (postList.length >= 4)
                                  ? SliverQuiltedGridDelegate(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 6,
                                      crossAxisSpacing: 6,
                                      repeatPattern:
                                          QuiltedGridRepeatPattern.inverted,
                                      pattern: [
                                        QuiltedGridTile(2, 1),
                                        QuiltedGridTile(1, 1),
                                        QuiltedGridTile(1, 1),
                                        QuiltedGridTile(1, 2),
                                      ],
                                    )
                                  : SliverQuiltedGridDelegate(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 6,
                                      crossAxisSpacing: 6,
                                      repeatPattern:
                                          QuiltedGridRepeatPattern.inverted,
                                      pattern: [QuiltedGridTile(1, 1)],
                                    ),
                              childrenDelegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  // (postList.length == 0)
                                  //     ? Container()
                                  //     :
                                  return (postList[index].urlImage != '')
                                      ? ImageWidget(
                                          src: postList[index].urlImage,
                                          postId: postList[index].id,
                                          uid: uid,
                                          position: index.toString(),
                                        )
                                      : VideoWidget(
                                          src: postList[index].urlVideo,
                                          postId: postList[index].id,
                                          uid: uid,
                                          position: index.toString(),
                                        );
                                },
                                childCount: postList.length,
                              ),
                            ),
                          )
                        ]))
                      ]))))
        ])));
  }
}
