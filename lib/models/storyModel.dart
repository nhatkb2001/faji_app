import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class storyModel {
  final String id;
  final String idUser;
  final String urlImage;
  final String urlVideo;
  final String mode;
  final String timeCreate;
  final String state;
  final String ownerAvatar;
  final String ownerUsername;
  final List likes;
  storyModel(
      {required this.id,
      required this.idUser,
      required this.urlImage,
      required this.urlVideo,
      required this.mode,
      required this.timeCreate,
      required this.state,
      required this.ownerAvatar,
      required this.likes,
      required this.ownerUsername});

  factory storyModel.fromDocument(Map<String, dynamic> doc) {
    return storyModel(
        id: doc['id'],
        idUser: doc['userId'],
        urlImage: doc['urlImage'],
        urlVideo: doc['urlVideo'],
        mode: doc['mode'],
        timeCreate: doc['timeCreate'],
        state: doc['state'],
        likes: doc['likes'],
        ownerAvatar: doc['ownerAvatar'],
        ownerUsername: doc['ownerUsername']);
  }
}
