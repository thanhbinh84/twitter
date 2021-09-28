import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mms/blocs/auth/auth_bloc.dart';
import 'package:mms/blocs/auth/auth_states.dart';
import 'package:mms/views/screens/login_screen.dart';
import 'package:mms/views/screens/main_screen.dart';

class Root extends StatefulWidget {
  Root({
    Key? key,
  }) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  late AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _authCubit.appStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return MainScreen();
        }

        if (state is AuthenticationUnauthenticated) {
          return LoginScreen();
        }

        return Container(color: Colors.white);
      },
    );
  }
}
