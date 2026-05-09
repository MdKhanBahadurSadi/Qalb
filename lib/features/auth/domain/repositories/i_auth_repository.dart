import '../entities/app_user.dart';

abstract class IAuthRepository {
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> signUp(String email, String password, String name);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
}
