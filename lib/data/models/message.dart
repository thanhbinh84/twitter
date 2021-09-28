import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mms/common/utils.dart';

enum Type { sent, received }

const MAX_MESSAGE_LENGTH = 280;

class Message {
  String id = '';
  String text = '';
  DateTime date = DateTime.now();
  String userId = '';
  Type type = Type.received;

  static const KEY_TEXT = 'text';
  static const KEY_DATE = 'date';
  static const KEY_USER_ID = 'user_id';

  Message({required this.text, required this.date, this.userId = ''});

  Map<String, dynamic> toJson() {
    return {
      KEY_TEXT: text,
      KEY_DATE: date.millisecondsSinceEpoch,
      KEY_USER_ID: userId,
    };
  }

  Message.fromJson(QueryDocumentSnapshot snapshot, String? currentUserId) {
    Map<String, dynamic> map = snapshot.data();
    id = snapshot.id;
    text = map[KEY_TEXT];
    date = DateTime.fromMillisecondsSinceEpoch(map[KEY_DATE]);
    userId = map[KEY_USER_ID];
    type = currentUserId == userId ? Type.sent : Type.received;
  }

  get time => Utils.convertToTimeString(date);

  get isAuthor => type == Type.sent;
}