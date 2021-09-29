import 'package:bloc/bloc.dart';
import 'package:mms/blocs/message/message_states.dart';
import 'package:mms/data/models/message.dart';
import 'package:mms/data/models/user.dart';
import 'package:mms/data/repositories/message_repository.dart';
import 'package:mms/data/repositories/user_repository.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository messageRepository;
  final UserRepository userRepository;

  MessageCubit({required this.messageRepository, required this.userRepository}) : super(MessageInitial());

  getMessages() async {
    try {
      emit(MessageLoadInProgress());
      messageRepository.getMessages(userRepository.getUser().id).forEach((element) {
        emit(MessageLoadSuccess(messages: element));
      });
    } catch (e) {
      addError(e);
    }
  }

  addMessage(Message message) async {
    try {
      if (message.userId.isNotEmpty)
        messageRepository.updateMessage(message);
      else {
        User user = userRepository.getUser();
        messageRepository.addMessage(Message(
            text: message.text, date: DateTime.now(), userId: user.id, userName: user.name));
      }
    } catch (e) {
      addError(e);
    }
  }

  deleteMessage(Message message) async {
    try {
      messageRepository.deleteMessage(message);
    } catch (e) {
      addError(e);
    }
  }
}
