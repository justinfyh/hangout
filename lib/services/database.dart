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

  final CollectionReference friendshipsCollection =
      FirebaseFirestore.instance.collection('friendships');

  Future<void> addFriend(String uid, String friendUid) async {
    try {
      final docRef = await friendshipsCollection.add({
        'friendshipId': "",
        'user1Id': uid,
        'user2Id': friendUid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final docId = docRef.id;

      await friendshipsCollection.doc(docId).update({'friendshipId': docId});
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendFriendRequest(
      String currentUserId, String targetUserId) async {
    // final request = {
    //   'fromUserId': currentUserId,
    //   'status': 'pending',
    //   // 'createdAt': FieldValue.serverTimestamp(),
    // };

    final targetUserDocRef =
        FirebaseFirestore.instance.collection('users').doc(targetUserId);
    await targetUserDocRef.update({
      'requests': FieldValue.arrayUnion([currentUserId]),
    });
  }

  Future<void> updateUser(
      String uid, String name, String email, String profileImageUrl) async {
    try {
      await usersCollection.doc(uid).update({
        'name': name,
        'email': email,
        'profileImageUrl': profileImageUrl,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createEvent(String eventName, String dateTime, String location,
      String details, String ownerUid, String imageUrl) async {
    try {
      await eventsCollection.add({
        'event_name': eventName,
        'location': location,
        'date_time': dateTime,
        'details': details,
        'owner_uid': ownerUid,
        'image_url': imageUrl,
      });
    } catch (e) {
      print("Failed to add event: $e");
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
          name: doc.get('event_name') ?? '',
          location: doc.get('location') ?? '',
          dateTime: doc.get('date_time') ?? 0,
          details: doc.get('details'),
          ownerUid: doc.get('owner_uid'),
          imageUrl: doc.get('image_url'));
    }).toList();
  }

  Stream<List<Event>> get events {
    return eventsCollection.snapshots().map(_eventListFromSnapshot);
  }

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot.id,
      name: data['name'] as String,
      email: data['email'] as String,
      friends: List<String>.from(data['friends']),
      requests: List<String>.from(data['requests']),
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
}
