import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/app_user.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().map(_mapFirebaseUser);

  AppUser? get currentUser => _mapFirebaseUser(_auth.currentUser);

  AppUser? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      isEmailVerified: user.emailVerified,
    );
  }

  Future<AppUser> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw AuthException('লগইন করতে ব্যর্থ হয়েছে');
      }
      return _mapFirebaseUser(credential.user)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException('একটি অজানা ভুল হয়েছে: $e');
    }
  }

  Future<AppUser> signUp(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw AuthException('নিবন্ধন করতে ব্যর্থ হয়েছে');
      }
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      final updatedUser = _auth.currentUser;
      return _mapFirebaseUser(updatedUser)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException('একটি অজানা ভুল হয়েছে: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  AuthException _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = "এই ইমেইলে কোনো account নেই";
        break;
      case 'wrong-password':
        message = "পাসওয়ার্ড ভুল";
        break;
      case 'email-already-in-use':
        message = "এই ইমেইল ইতোমধ্যে ব্যবহৃত";
        break;
      case 'invalid-email':
        message = "ইমেইলটি সঠিক নয়";
        break;
      case 'weak-password':
        message = "পাসওয়ার্ডটি অত্যন্ত দুর্বল";
        break;
      case 'network-request-failed':
        message = "ইন্টারনেট সংযোগ চেক করুন";
        break;
      case 'user-disabled':
        message = "এই অ্যাকাউন্টটি বন্ধ করে দেওয়া হয়েছে";
        break;
      default:
        message = "একটি ভুল হয়েছে: ${e.message ?? e.code}";
    }
    return AuthException(message, code: e.code);
  }
}
