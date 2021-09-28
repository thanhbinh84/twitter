import 'package:bloc/bloc.dart';
import 'package:mms/blocs/auth/auth_states.dart';
import 'package:mms/data/repositories/user_repository.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  final UserRepository userRepository;

  AuthCubit({
    required this.userRepository,
  }) : super(AuthenticationUninitialized());

  Future<void> appStarted() async {
    String? userId = userRepository.getUserId();
    if (userId != null) {
      emit(AuthenticationAuthenticated(userId: userId));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> signInGoogle() async {
    try {
      await userRepository.authenticate();
      await appStarted();
    } catch (e) {
      addError(e);
    }
  }

  Future<void> loggedOut() async {
    await userRepository.signOut();
    emit(AuthenticationUnauthenticated());
  }
}
