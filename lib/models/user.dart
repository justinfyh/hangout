class UserIdentity {
  final String uid;
  UserIdentity({required this.uid});
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<dynamic> friends;
  final List<dynamic> savedEvents;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.friends,
    required this.savedEvents,
    required this.profileImageUrl,
  });

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

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
      savedEvents: List<String>.from(map['savedEvents']),
      friends: List<String>.from(map['friends']),
    );
  }
}
