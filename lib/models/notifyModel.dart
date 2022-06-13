import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class notifyModel {
  final String id;
  final String idSender;
  final String idReceiver;
  final String idPost;
  final String content;
  final String category;
  final String mode;
  final String avatarSender;
  final String nameSender;
  final String timeCreate;

  notifyModel(
      {required this.id,
      required this.idSender,
      required this.idPost,
      required this.idReceiver,
      required this.avatarSender,
      required this.mode,
      required this.category,
      required this.content,
      required this.timeCreate,
      required this.nameSender});

  factory notifyModel.fromDocument(Map<String, dynamic> doc) {
    return notifyModel(
        id: doc['id'],
        idSender: doc['idSender'],
        idPost: doc['idPost'],
        idReceiver: doc['idReceiver'],
        avatarSender: doc['avatarSender'],
        mode: doc['mode'],
        category: doc['category'],
        content: doc['content'],
        timeCreate: doc['timeCreate'],
        nameSender: doc['nameSender']);
  }
}
