import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class likedModel {
  final String id;
  final String idPost;
  final String idUser;
  final String timeCreate;
  final String state;
  likedModel({
    required this.id,
    required this.idUser,
    required this.idPost,
    required this.timeCreate,
    required this.state,
  });

  factory likedModel.fromDocument(Map<String, dynamic> doc) {
    return likedModel(
      id: doc['id'],
      idUser: doc['userId'],
      idPost: doc['postId'],
      timeCreate: doc['timeCreate'],
      state: doc['state'],
    );
  }
}
