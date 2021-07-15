import 'package:firebase_auth/firebase_auth.dart';

class FBAuthService {
  final FirebaseAuth _firebaseAuth;

  UserCredential? userCredential;

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential!.user!.uid);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(userCredential!.user!.uid);
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  FBAuthService(this._firebaseAuth);
}
