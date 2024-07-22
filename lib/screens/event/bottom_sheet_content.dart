import 'package:flutter/material.dart';
import 'package:hangout/services/database.dart';

class BottomSheetContent extends StatefulWidget {
  final String eventId;
  final String userId;
  final String currentStatus;

  const BottomSheetContent({
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
    } else if (status == 'Can\'t go') {
      await db.setNotGoingEvent(widget.userId, widget.eventId);
    }
  }
}
