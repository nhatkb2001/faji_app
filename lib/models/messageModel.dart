import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String userId1;
  final String userId2;
  final List contentList;
  final String messageId;
  final String lastTimeSend;
  final String name1;
  final String lastMessage;
  final String name2;
  final String background1;
  final String background2;

  Message({
    required this.contentList,
    required this.userId1,
    required this.userId2,
    required this.messageId,
    required this.lastTimeSend,
    required this.lastMessage,
    required this.name2,
    required this.name1,
    required this.background1,
    required this.background2,
  });
  factory Message.fromDocument(Map<String, dynamic> doc) {
    return Message(
        contentList: doc['contentList'],
        messageId: doc['messageId'],
        userId1: doc['userId1'],
        userId2: doc['userId2'],
        lastMessage: doc['lastMessage'],
        lastTimeSend: doc['lastTimeSend'],
        background1: doc['background1'],
        background2: doc['background2'],
        name1: doc['name1'],
        name2: doc['name2']);
  }
}
