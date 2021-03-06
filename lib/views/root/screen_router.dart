import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mms/blocs/auth/auth_cubit.dart';
import 'package:mms/blocs/message/message_cubit.dart';
import 'package:mms/data/repositories/firebase_message_repository.dart';
import 'package:mms/data/repositories/firebase_user_repository.dart';
import 'package:mms/data/repositories/message_repository.dart';
import 'package:mms/data/repositories/user_repository.dart';
import 'package:mms/views/root/root.dart';

class ScreenRouter {
  static const ROOT = '/';

  late MessageRepository messageRepository;
  late UserRepository userRepository;

  ScreenRouter() {
    messageRepository = FirebaseMessageRepository();
    userRepository = FirebaseUserRepository();
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var route = buildPageRoute(settings);

    print('>>>>>>> GOTO: ${settings.name}');
    switch (settings.name) {
      case ROOT:
        return route(Root());
      default:
        return unknownRoute(settings);
    }
  }

  Function buildPageRoute(RouteSettings settings) {
    List<BlocProvider> blocProviders = [
      BlocProvider<MessageCubit>(
          create: (context) =>
              MessageCubit(messageRepository: messageRepository, userRepository: userRepository)),
      BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(userRepository: userRepository),
      ),
    ];

    return (Widget child, {fullScreen = false}) => MaterialPageRoute(
          fullscreenDialog: fullScreen,
          builder: (context) => MultiBlocProvider(
            providers: blocProviders,
            child: child,
          ),
          settings: settings,
        );
  }

  Route<dynamic> unknownRoute(RouteSettings settings) {
    var unknownRouteText = "No such screen for ${settings.name}";

    return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unknownRouteText),
          Padding(padding: const EdgeInsets.all(10.0)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Back'),
          ),
        ],
      );
    });
  }
}
