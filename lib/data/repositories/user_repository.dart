import 'package:mms/data/models/user.dart';

abstract class UserRepository {
  Future<bool> isAuthenticated();

  Future<void> authenticate();

  Future<void> signOut();

  User getUser();
}
