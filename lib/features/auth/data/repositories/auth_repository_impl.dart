import '../../domain/entities/app_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<AppUser?> get authStateChanges => _datasource.authStateChanges;

  @override
  AppUser? get currentUser => _datasource.currentUser;

  @override
  Future<AppUser> signIn(String email, String password) {
    return _datasource.signIn(email, password);
  }

  @override
  Future<AppUser> signUp(String email, String password, String name) {
    return _datasource.signUp(email, password, name);
  }

  @override
  Future<void> signOut() {
    return _datasource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _datasource.sendPasswordResetEmail(email);
  }
}
