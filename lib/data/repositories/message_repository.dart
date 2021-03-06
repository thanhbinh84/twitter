import 'package:mms/data/models/message.dart';

abstract class MessageRepository {
  Future<void> addMessage(Message message);

  Future<void> deleteMessage(Message message);

  Stream<List<Message>> getMessages(String? userId);

  Future<void> updateMessage(Message message);
}
