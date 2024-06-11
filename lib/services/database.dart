import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addFriend(String uid) async {
    try {
      await usersCollection.doc(uid).update({
        'friends': FieldValue.arrayUnion(['cacaf4SJDuOpRlpB0EasIdjojlJ2'])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createEvent() async {
    try {
      await eventsCollection.add({
        'event_name': 'Party',
        'location': 'Albany Mall',
        'date': '10.06.2024',
        'time': '1200',
      });
    } catch (e) {
      print("Failed to add event: $e");
    }
  }

  // Future<UserModel?> getUserById(String uid) async {
  //   try {
  //     DocumentSnapshot doc = await usersCollection.doc(uid).get();
  //     if (doc.exists) {
  //       return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  //     }
  //     return null;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
          name: doc.get('event_name') ?? '',
          location: doc.get('location') ?? '',
          date: doc.get('date') ?? 0);
    }).toList();
  }

  Stream<List<Event>> get events {
    // print(eventsCollection.snapshots().map(_eventListFromSnapshot));

    return eventsCollection.snapshots().map(_eventListFromSnapshot);
  }

  // UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
  //   var data = snapshot.data() as Map<String, dynamic>;
  //   return UserModel(
  //     uid: snapshot.id,
  //     name: data['name'] as String,
  //     email: data['email'] as String,
  //     friends: data['friends'] as List<String>,
  //     savedEvents: data['savedEvents'] as List<dynamic>,
  //     profileImageUrl: data['friends']['profileImageUrl'] as String,
  //   );
  // }

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot.id,
      name: data['name'] as String,
      email: data['email'] as String,
      friends: List<String>.from(data['friends']),
      savedEvents: data['savedEvents'] as List<dynamic>,
      profileImageUrl: data['profileImageUrl'] as String,
    );
  }

  Stream<UserModel?> get userData {
    return usersCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userDataFromSnapshot(snapshot))
        .handleError((error) {
      print('Error: $error');
      return null; // Handle error by returning null
    });
  }

  // Stream<UserModel> get userData {
  //   return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
