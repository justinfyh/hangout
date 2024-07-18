import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:hangout/services/storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _privacyController = TextEditingController();

  final StorageService _storage = StorageService();
  final List<String> _invitedUsers = [];

  String? _selectedImagePath;
  String? _downloadUrl;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
  }

  Future<void> _selectDateTime(BuildContext context) async {
    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
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
      if (imagePath != null && mounted) {
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

  Future<void> _clearForm() async {
    _eventNameController.clear();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
    _locationController.clear();
    _detailsController.clear();
    if (mounted) {
      setState(() {
        _selectedImagePath = null;
        _downloadUrl = null;
        _isPrivate = false;
        _invitedUsers.clear();
      });
    }
  }

  Future<void> _submitForm(DatabaseService db) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (BuildContext context) =>
        //       const Center(child: CircularProgressIndicator()),
        // );

        // Upload image
        await _uploadImage();

        // Create event
        await db.createEvent(
          _eventNameController.text,
          _dateTimeController.text,
          _locationController.text,
          _detailsController.text,
          db.uid,
          _downloadUrl ?? '',
          _isPrivate,
          _invitedUsers,
        );

        // Clear form
        _clearForm();
        // await _clearForm();
        print("OKAY");
        // Dismiss loading indicator and current page
        // FocusScope.of(context).unfocus();

        DefaultTabController.of(context).animateTo(0);

        if (mounted) {
          print("IN");

          // Navigator.of(context).pop(); // Close loading indicator
          // Navigator.of(context).pop(); // Close create event page
        }
        print("OUT");
      } catch (e) {
        debugPrint('Error creating event: $e');
        // Handle error or exception (e.g., show error message)
        // if (mounted) {
        //   Navigator.of(context).pop(); // Close loading indicator
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //         content: Text('Failed to create event. Please try again.')),
        //   );
        // }
      }
    }
  }

  void _showPrivacyDialog() async {
    bool? isPrivate = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        title: const Text('Create Event'),
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
                      ? null
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
                              backgroundColor:
                                  Theme.of(context).primaryColor, // Text color
                            ),
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
              // const SizedBox(height: 20),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {},
              //         child: const Text('Add end time'),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {},
              //         child: const Text('Repeat event'),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {},
              //         child: const Text('UTC+12'),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                    labelText: 'Location', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _showPrivacyDialog,
              //   child: const Text('Who can see it?'),
              // ),
              InkWell(
                onTap: _showPrivacyDialog,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _privacyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: _isPrivate ? 'Private' : 'Public',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isPrivate)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Invite Users'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _invitedUsers
                          .map((user) => Chip(
                                label: Text(user),
                                onDeleted: () {
                                  setState(() {
                                    _invitedUsers.remove(user);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Enter email to invite',
                          border: OutlineInputBorder()),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty &&
                            !_invitedUsers.contains(value)) {
                          setState(() {
                            _invitedUsers.add(value);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                    labelText: 'What are the details?',
                    border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () => _submitForm(db),
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(vertical: 15),
              //     textStyle: const TextStyle(fontSize: 18),
              //   ),
              //   child: const Text('Create event'),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _submitForm(db),
        label: const Text(
          'Create Event',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
