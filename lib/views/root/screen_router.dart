import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mms/blocs/auth/auth_bloc.dart';
import 'package:mms/blocs/chart/chart_cubit.dart';
import 'package:mms/data/repositories/chart_repos.dart';
import 'package:mms/data/repositories/firebase_user_repository.dart';
import 'package:mms/data/repositories/user_repository.dart';
import 'package:mms/data/services/api.dart';
import 'package:mms/data/services/mocks/mock_api.dart';
import 'package:mms/views/root/root.dart';

class ScreenRouter {
  static const ROOT = '/';

  late ChartRepository issueRepository;
  late UserRepository userRepository;
  late BaseAPI api;

  ScreenRouter() {
    api = MockAPI();

    issueRepository = ChartRepository(api: api);
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
      BlocProvider<ChartCubit>(
        create: (context) => ChartCubit(
          issueRepository: issueRepository,
        ),
      ),
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
