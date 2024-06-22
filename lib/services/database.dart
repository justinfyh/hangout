import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

// get collection references
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference friendshipsCollection =
      FirebaseFirestore.instance.collection('friendships');

// FRIENDSHIPS ------------------------------------------------------------------
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
    final targetUserDocRef =
        FirebaseFirestore.instance.collection('users').doc(targetUserId);
    await targetUserDocRef.update({
      'requests': FieldValue.arrayUnion([currentUserId]),
    });
  }

  Future<void> acceptFriendRequest(
      String currentUserId, String targetUserId) async {
    addFriend(currentUserId, targetUserId);
    await usersCollection.doc(currentUserId).update({
      'requests': FieldValue.arrayRemove([targetUserId])
    });
  }

  Future<void> declineFriendRequest(
      String currentUserId, String targetUserId) async {
    await usersCollection.doc(currentUserId).update({
      'requests': FieldValue.arrayRemove([targetUserId])
    });
  }

  Future<List<String>> getFriends(String uid) async {
    List<String> friends = [];
    try {
      QuerySnapshot querySnapshot =
          await friendshipsCollection.where('user1Id', isEqualTo: uid).get();
      querySnapshot.docs.forEach((doc) {
        friends.add(doc['user2Id']);
      });

      querySnapshot =
          await friendshipsCollection.where('user2Id', isEqualTo: uid).get();
      querySnapshot.docs.forEach((doc) {
        friends.add(doc['user1Id']);
      });
    } catch (e) {
      print('Error getting friends: $e');
    }
    return friends;
  }

// USERS -----------------------------------------------------------------------
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

//  EVENTS ------------------------------------------------------------------
  Future<void> createEvent(String eventName, String dateTime, String location,
      String details, String ownerUid, String imageUrl) async {
    try {
      final docRef = await eventsCollection.add({
        'event_name': eventName,
        'location': location,
        'date_time': dateTime,
        'details': details,
        'owner_uid': ownerUid,
        'image_url': imageUrl,
        'going': [ownerUid],
        'interested': []
      });
      final docId = docRef.id;

      await eventsCollection.doc(docId).update({'event_id': docId});
    } catch (e) {
      print("Failed to add event: $e");
    }
  }

  Future<void> sendMessage(String eventId, String text) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('messages')
        .add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user.uid,
    });
  }

  Future<Event?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await eventsCollection.doc(eventId).get();
      if (doc.exists) {
        return Event(
            name: doc.get('event_name') ?? '',
            location: doc.get('location') ?? '',
            dateTime: doc.get('date_time') ?? 0,
            details: doc.get('details'),
            ownerUid: doc.get('owner_uid'),
            imageUrl: doc.get('image_url'),
            eventId: doc.get('event_id'),
            going: doc.get('going'),
            interested: doc.get('interested'));
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> setGoingEvent(String userId, String eventId) async {
    await eventsCollection.doc(eventId).update({
      'going': FieldValue.arrayUnion([userId])
    });
    await eventsCollection.doc(eventId).update({
      'interested': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> setInterestedEvent(String userId, String eventId) async {
    await eventsCollection.doc(eventId).update({
      'interested': FieldValue.arrayUnion([userId])
    });
    await eventsCollection.doc(eventId).update({
      'going': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> setNotGoingEvent(String userId, String eventId) async {
    await eventsCollection.doc(eventId).update({
      'going': FieldValue.arrayRemove([userId])
    });
    await eventsCollection.doc(eventId).update({
      'interested': FieldValue.arrayRemove([userId])
    });
  }

  // FROM SNAPSHOTS -----------------------------------------------------------
  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
          name: doc.get('event_name') ?? '',
          location: doc.get('location') ?? '',
          dateTime: doc.get('date_time') ?? 0,
          details: doc.get('details'),
          ownerUid: doc.get('owner_uid'),
          imageUrl: doc.get('image_url'),
          eventId: doc.get('event_id'),
          going: doc.get('going'),
          interested: doc.get('interested'));
    }).toList();
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

  // STREAMS ---------------------------------------------------------------------
  Stream<List<Event>> get events {
    return eventsCollection.snapshots().map(_eventListFromSnapshot);
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

  Stream<QuerySnapshot> getMessages(String eventId) {
    return FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
