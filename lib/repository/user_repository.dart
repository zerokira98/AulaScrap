import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (_firebaseAuth.currentUser).email;
  }

  Future<String> getUserPpUrl() async {
    return (_firebaseAuth.currentUser).photoURL;
  }

  Future updatePp(String url) async {
    // UserUpdateInfo info = new UserUpdateInfo();
    // info.photoUrl = url;

    return (_firebaseAuth.currentUser).updatePhotoURL(url);
  }

  Future setUser(String username) async {
    // UserUpdateInfo info = new UserUpdateInfo();
    // info.displayName = username;
    return (_firebaseAuth.currentUser).updateDisplayName(username);
  }

  Future<String> getUserName() async {
    return (_firebaseAuth.currentUser).displayName;
  }

  Future<String> getUserId() async {
    return (_firebaseAuth.currentUser).uid;
  }
}
