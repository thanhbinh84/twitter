// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mms/blocs/message/message_cubit.dart';
import 'package:mms/blocs/theme/theme_cubit.dart';
import 'package:mms/data/models/message.dart';
import 'package:mms/data/models/user.dart';
import 'package:mms/data/repositories/message_repository.dart';
import 'package:mms/data/repositories/user_repository.dart';
import 'package:mms/views/screens/main_screen.dart';
import 'package:mockito/mockito.dart';

class MockMessageRepository extends Mock implements MessageRepository {}

class MockUserRepository extends Mock implements UserRepository {}

Widget makeWidgetTestable({ Widget child, messageCubit}) {
  return MaterialApp(
      home: MultiBlocProvider(
          providers: [
            BlocProvider<MessageCubit>(
              create: (context) {
                return messageCubit;
              },
            ),
            BlocProvider<ThemeCubit>(
              create: (context) {
                return ThemeCubit();
              },
            ),
          ],
          child: BlocProvider(
              create: (_) => ThemeCubit(),
              child: BlocBuilder<ThemeCubit, ThemeData>(builder: (_, theme) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    home: child,
                    onGenerateRoute: (_) =>
                        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                          return Text('mock page');
                        }));
              }))));
}

void main() {
  testGoldens('Message screen should render correctly on multiple screens', (tester) async {
    MockMessageRepository messageRepository = MockMessageRepository();
    List<Message> messages = [
      Message(date: DateTime.now(),
          text: 'Long long Long long Long long Long long Long long Long long Long long Long long text',
          userName: 'long long long long name'),
      Message(date: DateTime.now(),
          text: 'Long long Long long Long long Long long Long long Long long Long long Long long text',
          userName: 'short name'),
      Message(date: DateTime.now(), text: 'short text', userName: 'long long long long name'),
      Message(date: DateTime.now(), text: 'short text', userName: 'short name'),
    ];
    when(messageRepository.getMessages(any)).thenAnswer((_) => Stream.fromIterable([messages]));

    MockUserRepository userRepository = MockUserRepository();
    when(userRepository.getUser()).thenReturn(User());
    MessageCubit messageCubit = MessageCubit(
        messageRepository: messageRepository, userRepository: userRepository);

    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addScenario(
        widget: makeWidgetTestable(child: MainScreen(), messageCubit: messageCubit),
        name: 'Message screen',
      )..addScenario(
        widget: makeWidgetTestable(child: MainScreen(), messageCubit: messageCubit),
        name: 'Dark mode',
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.light),
          );
          expect(finder, findsOneWidget);
          await tester.tap(finder);
        },
      )..addScenario(
        widget: makeWidgetTestable(child: MainScreen(), messageCubit: messageCubit),
        name: 'Light mode',
        onCreate: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.light),
          );
          expect(finder, findsOneWidget);

          await tester.tap(finder);
          await tester.tap(finder);
        },
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'multiple_screens_testing');
  });
}
