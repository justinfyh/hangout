import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:hangout/services/storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatefulWidget {
  final Event event;

  const EditEventPage({super.key, required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _dateTimeController;
  late TextEditingController _locationController;
  late TextEditingController _detailsController;
  late TextEditingController _privacyController;

  final StorageService _storage = StorageService();
  String? _selectedImagePath;
  String? _downloadUrl;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _eventNameController = TextEditingController(text: event.name);
    _dateTimeController = TextEditingController(text: event.dateTime);
    _locationController = TextEditingController(text: event.location);
    _detailsController = TextEditingController(text: event.details);
    _privacyController =
        TextEditingController(text: event.isPrivate ? 'Private' : 'Public');
    _isPrivate = event.isPrivate;
    _downloadUrl = event.imageUrl;
    _selectedImagePath =
        null; // Optional: if you want to allow re-uploading of image
  }

  Future<void> _selectDateTime(BuildContext context) async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate:
            DateFormat('MMM dd, yyyy HH:mm').parse(_dateTimeController.text),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
              DateFormat('MMM dd, yyyy HH:mm').parse(_dateTimeController.text)),
        );
        if (pickedTime != null) {
          final DateTime combined = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (mounted) {
            setState(() {
              _dateTimeController.text =
                  DateFormat('MMM dd, yyyy HH:mm').format(combined);
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error selecting date and time: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      String? imagePath = await _storage.pickImage();
      if (mounted) {
        setState(() {
          _selectedImagePath = imagePath;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_selectedImagePath != null) {
        String url = await _storage.uploadImage(_selectedImagePath!);
        if (mounted) {
          setState(() {
            _downloadUrl = url;
          });
        }
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }

  Future<void> _submitForm(DatabaseService db) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_selectedImagePath != null) {
          await _uploadImage();
        }

        await db.updateEvent(
          widget.event.eventId,
          _eventNameController.text,
          _dateTimeController.text,
          _locationController.text,
          _detailsController.text,
          _downloadUrl ?? widget.event.imageUrl,
          _isPrivate,
        );

        Navigator.of(context).pop(); // Close edit event page
      } catch (e) {
        debugPrint('Error updating event: $e');
      }
    }
  }

  void _showPrivacyDialog() async {
    bool? isPrivate = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Event Privacy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Public'),
                onTap: () {
                  Navigator.of(context).pop(false); // Return false (public)
                },
              ),
              ListTile(
                title: const Text('Private'),
                onTap: () {
                  Navigator.of(context).pop(true); // Return true (private)
                },
              ),
            ],
          ),
        );
      },
    );

    if (isPrivate != null) {
      setState(() {
        _isPrivate = isPrivate;
        _privacyController.text = _isPrivate ? 'Private' : 'Public';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final String uid = user.uid;
    final DatabaseService db = DatabaseService(uid: uid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Event',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: _selectedImagePath == null
                      ? (_downloadUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_downloadUrl!),
                              fit: BoxFit.cover,
                            )
                          : null)
                      : DecorationImage(
                          image: FileImage(File(_selectedImagePath!)),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context)
                                    .primaryColor, // Text color
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text('Choose Image'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                    labelText: 'Event Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: const InputDecoration(
                    labelText: 'Start date and time',
                    border: OutlineInputBorder()),
                onTap: () => _selectDateTime(context),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                    labelText: 'Location', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _showPrivacyDialog,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _privacyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Privacy',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                    labelText: 'What are the details?',
                    border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _submitForm(db),
        label: const Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    _privacyController.dispose();
    super.dispose();
  }
}
