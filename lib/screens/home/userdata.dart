import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangout/models/user.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  // final String uid = 'A8GKGqEkwUXs258EC1zL1CPZ9qE2'; // Example UID

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final String uid = user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Stream'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return UserDetails(userData: userData);
        },
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final Map<String, dynamic> userData;

  UserDetails({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: ${userData['friends']}'),
          // Text('Friend Name: ${userData['friends']['name']}'),
          // Text(
          //     'Friend Profile Image URL: ${userData['friends']['profileImageUrl']}'),
          // Text('Saved Event UID: ${userData['savedEvents']['uid']}'),
        ],
      ),
    );
  }
}
