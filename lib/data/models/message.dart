import 'package:mms/common/utils.dart';

enum Type { sent, received }

const MAX_MESSAGE_LENGTH = 280;

class Message {
  String id = '';
  String text = '';
  DateTime date = DateTime.now();
  String peerId = '';

  static const KEY_TEXT = 'text';
  static const KEY_DATE = 'date';
  static const KEY_USER_ID = 'user_id';

  Message({required this.text, required this.date, this.peerId = ''});

  Map<String, dynamic> toJson() {
    return {
      KEY_TEXT: text,
      KEY_DATE: date.millisecondsSinceEpoch,
      KEY_USER_ID: peerId,
    };
  }

  Message.fromJson(Map<String, dynamic> map) {
    text = map[KEY_TEXT];
    date = DateTime.fromMillisecondsSinceEpoch(map[KEY_DATE]);
    peerId = map[KEY_USER_ID];
  }

  Type get type => peerId.isEmpty ? Type.sent : Type.received;

  get time => Utils.convertToTimeString(date);

  get isReceived => type == Type.received;
}