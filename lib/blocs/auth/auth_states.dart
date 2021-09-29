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
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationError extends AuthenticationState {
  @override
  String toString() => 'AuthenticationError';
}
