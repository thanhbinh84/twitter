import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  final List<Object?>? objProps;
  const AuthenticationState([this.objProps]);

  List<Object?> get props => objProps ?? [];
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  final String userId;

  AuthenticationAuthenticated({required this.userId}) : super([userId]);

  @override
  String toString() => 'AuthenticationAuthenticated $userId';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationError extends AuthenticationState {
  @override
  String toString() => 'AuthenticationError';
}
