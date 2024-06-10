import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangout/models/event.dart';

class DatabaseService {
  // final String uid;
  // DatabaseService({required this.uid});

  // final CollectionReference brewCollection =
  //     FirebaseFirestore.instance.collection('brews');

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addFriend(String uid) async {
    try {
      await usersCollection.doc(uid).update({
        'friends': FieldValue.arrayUnion(['cacaf4SJDuOpRlpB0EasIdjojlJ2'])
      });
    } catch (e) {}
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

  List<Event> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Event(
          name: doc.get('event_name') ?? '',
          location: doc.get('location') ?? '',
          date: doc.get('date') ?? 0);
    }).toList();
  }

  Stream<List<Event>> get events {
    return eventsCollection.snapshots().map(_eventListFromSnapshot);
  }
}
