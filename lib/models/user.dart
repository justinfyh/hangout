import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String profileImageUrl;
  List<String> friends;
  List<String> savedEvents;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.friends,
    required this.savedEvents,
  });

  // Convert a UserModel object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'friends': friends,
      'savedEvents': savedEvents,
    };
  }

  // Create a UserModel object from a Map object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
      friends: List<String>.from(map['friends']),
      savedEvents: List<String>.from(map['savedEvents']),
    );
  }

  // Fetch user data from Firestore by uid
  static Future<UserModel?> getUserById(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Save user data to Firestore
  Future<void> saveUser() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set(toMap());
  }
}
