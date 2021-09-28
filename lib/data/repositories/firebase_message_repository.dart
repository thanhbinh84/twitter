import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mms/data/models/message.dart';
import 'package:mms/data/repositories/message_repository.dart';

class FirebaseMessageRepository implements MessageRepository {
  final messageCollection = FirebaseFirestore.instance.collection('messages');


  @override
  Future<void> addMessage(Message message) {
    return messageCollection.add(message.toJson());
  }

  @override
  Future<void> deleteMessage(Message message) async {
    return messageCollection.doc(message.id).delete();
  }

  @override
  Stream<List<Message>> messages() {
    return messageCollection.orderBy(Message.KEY_DATE, descending: true) .snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Future<void> updateMessage(Message message) {
    return messageCollection.doc(message.id).update(message.toJson());
  }
}