// @dart=2.9
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mms/blocs/message/message_cubit.dart';
import 'package:mms/blocs/message/message_states.dart';
import 'package:mms/data/models/message.dart';
import 'package:mms/data/models/user.dart';
import 'package:mms/data/repositories/message_repository.dart';
import 'package:mms/data/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

class MockMessageRepository extends Mock implements MessageRepository {}
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('MessageCubit', () {
    MessageCubit messageCubit;
    MockMessageRepository messageRepository;
    MockUserRepository userRepository;
    List<Message> messages;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      messageRepository = MockMessageRepository();
      userRepository = MockUserRepository();
      messageCubit = MessageCubit(messageRepository: messageRepository, userRepository: userRepository);
      messages = [
        Message(date: DateTime.now(), text: 'test1'),
        Message(date: DateTime.now(), text: 'test2')
      ];
      when(userRepository.getUser()).thenReturn(User());
    });

    blocTest(
      'success case',
      build: () => messageCubit,
      act: (MessageCubit bloc) {
        when(messageRepository.getMessages(any)).thenAnswer((_) => Stream.fromIterable([messages]));
        bloc.getMessages();
      },
      expect: () => [isA<MessageLoadInProgress>(), isA<MessageLoadSuccess>()],
    );

    blocTest(
      'failure case',
      build: () => messageCubit,
      act: (MessageCubit bloc) {
        when(messageRepository.getMessages(any)).thenThrow(Exception());
        bloc.getMessages();
      },
      expect: () => [isA<MessageLoadInProgress>()],
      errors: () => [isA<Exception>()],
    );
  });
}
