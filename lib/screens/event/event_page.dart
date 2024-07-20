import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/event/group_chat.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

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
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder<UserModel?>(
                          future: db.getUserById(event.ownerUid),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Text.rich(
                                TextSpan(
                                  text: event.isPrivate ? 'Private' : 'Public',
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
                              );
                            } else {
                              return const Text('No data found');
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        SelectStatusButton(event: event, userId: user.uid),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 5),
                            Text(event.location),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline),
                            const SizedBox(width: 5),
                            Text(
                                '${event.going.length} going · ${event.interested.length} interested'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('What to expect',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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

class SelectStatusButton extends StatelessWidget {
  final Event event;
  final String userId;

  SelectStatusButton({required this.event, required this.userId});

  @override
  Widget build(BuildContext context) {
    String currentStatus = 'Select Status';
    if (event.going.contains(userId)) {
      currentStatus = 'Going';
    } else if (event.interested.contains(userId)) {
      currentStatus = 'Interested';
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Corrected border radius
        ),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomSheetContent(
              eventId: event.eventId,
              userId: userId,
              currentStatus: currentStatus,
            );
          },
        );
      },
      child: Text(currentStatus),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final String eventId;
  final String userId;
  final String currentStatus;

  BottomSheetContent({
    required this.eventId,
    required this.userId,
    required this.currentStatus,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  String? _selectedStatus;
  final List<String> _statuses = ['Going', 'Interested', 'Can\'t go'];
  late DatabaseService db;

  @override
  void initState() {
    super.initState();
    db = DatabaseService(uid: widget.userId);
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (String status in _statuses)
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatus = status; // Update the selected status
                });
                _updateStatusInDatabase(status); // Update status in database
              },
              child: ListTile(
                title: Text(status),
                leading: Radio<String>(
                  value: status,
                  groupValue: _selectedStatus,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                    _updateStatusInDatabase(
                        value!); // Update status in database
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _updateStatusInDatabase(String status) async {
    if (status == 'Going') {
      await db.setGoingEvent(widget.userId, widget.eventId);
    } else if (status == 'Interested') {
      await db.setInterestedEvent(widget.userId, widget.eventId);
    } else {
      await db.setNotGoingEvent(widget.userId, widget.eventId);
    }

    // Close the bottom sheet after updating the status
    Navigator.pop(context);
  }
}
