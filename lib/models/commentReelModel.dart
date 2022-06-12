import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class commentReelModel {
  final String id;
  final String idreel;
  final String idUser;
  final String content;
  final String timeCreate;
  final String state;
  final String ownerAvatar;
  final String ownerUsername;

  commentReelModel(
      {required this.id,
      required this.idUser,
      required this.idreel,
      required this.timeCreate,
      required this.content,
      required this.state,
      required this.ownerAvatar,
      required this.ownerUsername});

  factory commentReelModel.fromDocument(Map<String, dynamic> doc) {
    return commentReelModel(
        id: doc['id'],
        idUser: doc['userId'],
        idreel: doc['reelId'],
        timeCreate: doc['timeCreate'],
        content: doc['content'],
        state: doc['state'],
        ownerAvatar: doc['ownerAvatar'],
        ownerUsername: doc['ownerUsername']);
  }
}
