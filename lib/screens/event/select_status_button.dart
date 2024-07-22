import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/screens/event/bottom_sheet_content.dart';

class SelectStatusButton extends StatelessWidget {
  final Event event;
  final String userId;

  const SelectStatusButton({required this.event, required this.userId});

  @override
  Widget build(BuildContext context) {
    String currentStatus = 'Select Status';
    if (event.going.contains(userId)) {
      currentStatus = 'Going';
    } else if (event.interested.contains(userId)) {
      currentStatus = 'Interested';
    }

    return SizedBox(
      width: double.infinity, // Span the whole width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFFF7A00)
              .withOpacity(1), // Background color with 40% opacity
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentStatus,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white), // Drop-down icon
          ],
        ),
      ),
    );
  }
}
