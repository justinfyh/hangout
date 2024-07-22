import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/event/group_chat.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';
import 'package:hangout/screens/event/owner_manage_button.dart';
import 'package:hangout/screens/event/select_status_button.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;

  const EventDetailsPage({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    return StreamBuilder<Event?>(
      stream: db.getEvent(eventId),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (eventSnapshot.hasError) {
          return Center(child: Text('Error: ${eventSnapshot.error}'));
        } else if (!eventSnapshot.hasData) {
          return const Center(child: Text('Event not found'));
        } else {
          final event = eventSnapshot.data!;
          final isOwner = event.ownerUid == user.uid;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image and Details
                  Stack(
                    children: [
                      event.imageUrl.isNotEmpty
                          ? Image.network(
                              event.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/mascot.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/mascot.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Chip(
                          label: Text(
                            event.dateTime,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            event.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        FutureBuilder<UserModel?>(
                          future: db.getUserById(event.ownerUid),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Color(0xFFFF7A00),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Align(
                                alignment: Alignment.center,
                                child: Text.rich(
                                  TextSpan(
                                    text:
                                        event.isPrivate ? 'Private' : 'Public',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    children: <TextSpan>[
                                      const TextSpan(text: ' · Event by '),
                                      TextSpan(
                                        text: snapshot.data!.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const Text('No data found');
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        if (isOwner)
                          OwnerManageButton(eventId: eventId)
                        else
                          SelectStatusButton(event: event, userId: user.uid),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                event.location,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  '${event.going.length} going · ${event.interested.length} interested'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('What to expect',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(event.details),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatPage(
                      eventId: eventId,
                    ),
                  ),
                );
              },
              label: const Text(
                'Chat',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
