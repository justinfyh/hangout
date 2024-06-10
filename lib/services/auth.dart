import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hangout/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserModel?> get user {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
    // return _auth
    //     .authStateChanges()
    //     .map((User? user) => _userFromFirebaseUser(user));
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromCredUser(user));
  }

  UserModel? _userFromCredUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future registerEmailPassword(name, email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // Create a new user object
      // UserModel newUser = UserModel(
      //   uid: user!.uid,
      //   // name: name,
      //   // email: email,
      //   // profileImageUrl: '',
      //   // friends: [],
      //   // savedEvents: [],
      // );
      // await newUser.saveUser();
      if (user != null) {
        UserModel newUser = UserModel(uid: user.uid, name: name, email: email);
        await _db.collection('users').doc(user.uid).set(newUser.toMap());
        return newUser;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInEmailPassword(emailAddress, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      User? user = result.user;
      if (user != null) {
        return user;
      }
      print(result);
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      print('fff');
      print(_auth.currentUser);
      return user;
    } catch (e) {}
  }

  Future signOut() async {
    try {
      _auth.signOut();
    } catch (e) {}
  }
}
