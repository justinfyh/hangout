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
  final List<dynamic> requests;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.friends,
      required this.savedEvents,
      required this.profileImageUrl,
      required this.requests});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'friends': friends,
      'savedEvents': savedEvents,
      'requests': requests
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
        requests: List<String>.from(map['requests']));
  }
}
