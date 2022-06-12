import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class commentModel {
  final String id;
  final String idPost;
  final String idUser;
  final String content;
  final String timeCreate;
  final String state;
  final String ownerAvatar;
  final String ownerUsername;

  commentModel(
      {required this.id,
      required this.idUser,
      required this.idPost,
      required this.timeCreate,
      required this.content,
      required this.state,
      required this.ownerAvatar,
      required this.ownerUsername});

  factory commentModel.fromDocument(Map<String, dynamic> doc) {
    return commentModel(
        id: doc['id'],
        idUser: doc['userId'],
        idPost: doc['postId'],
        timeCreate: doc['timeCreate'],
        content: doc['content'],
        state: doc['state'],
        ownerAvatar: doc['ownerAvatar'],
        ownerUsername: doc['ownerUsername']);
  }
}
