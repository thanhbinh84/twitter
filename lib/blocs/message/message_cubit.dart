import 'package:bloc/bloc.dart';
import 'package:mms/blocs/message/message_states.dart';
import 'package:mms/data/models/message.dart';
import 'package:mms/data/repositories/message_repository.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageRepository messageRepository;

  MessageCubit({required this.messageRepository}) : super(MessageInitial());

  getMessages() async {
    try {
      emit(MessageLoadInProgress());
      messageRepository.messages().forEach((element) {
        emit(MessageLoadSuccess(messages: element));
      });
    } catch (e) {
      addError(e);
    }
  }

  addMessage(Message message) async {
    try {
      messageRepository.addMessage(message);
    } catch (e) {
      addError(e);
    }
  }
}
