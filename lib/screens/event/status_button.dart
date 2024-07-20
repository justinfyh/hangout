import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:provider/provider.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/services/database.dart';

class GoingButton extends StatelessWidget {
  final String eventId;

  const GoingButton({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    return StreamBuilder<Event>(
      stream: db.getEvent(eventId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final event = snapshot.data!;
        String? currentStatus;
        if (event.going.contains(user.uid)) {
          currentStatus = 'Going';
        } else if (event.interested.contains(user.uid)) {
          currentStatus = 'Interested';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          decoration: BoxDecoration(
            color: const Color(0xffFF7A00), // Custom color
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              value: currentStatus,
              hint: const Text(
                'Select Status',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              onChanged: (String? newValue) {
                if (newValue == 'Going') {
                  db.setGoingEvent(eventId, user.uid);
                } else if (newValue == 'Interested') {
                  db.setInterestedEvent(eventId, user.uid);
                } else {
                  db.setNotGoingEvent(eventId, user.uid);
                }
              },
              selectedItemBuilder: (BuildContext context) {
                return ['Going', 'Interested'].map<Widget>((String status) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList();
              },
              items: ['Going', 'Interested']
                  .map<DropdownMenuItem<String>>((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
