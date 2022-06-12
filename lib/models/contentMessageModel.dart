import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ffi';

class Content {
  final String userId;
  final String contentId;
  final String messageId;
  final String createAt;
  final String message;
  final String timeSendDetail;

  Content({
    required this.contentId,
    required this.userId,
    required this.messageId,
    required this.message,
    required this.createAt,
    required this.timeSendDetail,
  });
  factory Content.fromDocument(Map<String, dynamic> doc) {
    return Content(
        contentId: doc['contentId'],
        messageId: doc['messageId'],
        userId: doc['sendBy'],
        message: doc['content'],
        timeSendDetail: doc['timeSendDetail'],
        createAt: doc['timeSend']);
  }
}
