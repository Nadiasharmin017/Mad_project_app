import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  FirebaseAuth get _auth {
    if (Platform.isLinux) {
      throw UnsupportedError('Firebase Auth not supported on Linux');
    }
    return FirebaseAuth.instance;
  }

  Stream<User?> get authStateChanges {
    if (Platform.isLinux) {
      return const Stream.empty();
    }
    return _auth.authStateChanges();
  }

  Future<void> login(String email, String password) {
    if (Platform.isLinux) return Future.value();
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register(String email, String password) {
    if (Platform.isLinux) return Future.value();
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    if (Platform.isLinux) return Future.value();
    return _auth.signOut();
  }
}
