import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String content;
  String type;
  Timestamp time;
  String sender;
  String reciever;
  String status;

  MessageModel(
      {required this.sender,
      required this.reciever,
      required this.status,
      required this.type,
      required this.content,
      required this.time});
}
