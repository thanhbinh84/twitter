abstract class UserRepository {
  Future<bool> isAuthenticated();

  Future<void> authenticate();

  Future<void> signOut();

  String? getUserId();
}
