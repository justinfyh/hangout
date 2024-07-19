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
  final TextEditingController _searchController = TextEditingController();

  final StorageService _storage = StorageService();
  final List<String> _invitedUsers = [];
  List<UserModel> _suggestedUsers = []; // List to hold suggested UserModels

  String? _selectedImagePath;
  String? _downloadUrl;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
    _searchController.addListener(onSearchChanged);
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

  Future<void> _clearForm() async {
    _eventNameController.clear();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
    _locationController.clear();
    _detailsController.clear();
    _searchController.clear();
    if (mounted) {
      setState(() {
        _selectedImagePath = null;
        _downloadUrl = null;
        _isPrivate = false;
        _invitedUsers.clear();
        _suggestedUsers.clear();
      });
    }
  }

  Future<void> _submitForm(DatabaseService db) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _uploadImage();

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

        _clearForm();

        DefaultTabController.of(context).animateTo(0);

        if (mounted) {
          // Navigator.of(context).pop(); // Close create event page
        }
      } catch (e) {
        debugPrint('Error creating event: $e');
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

  Future<List<UserModel>> fetchUserSuggestions(String query, String uid) async {
    final userModels = await DatabaseService(uid: uid).searchUsers(query);
    return userModels;
  }

  void onSearchChanged() async {
    final query = _searchController.text.toLowerCase();
    final user = Provider.of<UserIdentity?>(context, listen: false);
    if (user != null) {
      final allUsers = await fetchUserSuggestions(query, user.uid);

      if (mounted) {
        setState(() {
          _suggestedUsers = allUsers
              .where((user) => user.name.toLowerCase().contains(query))
              .toList();
        });
      }
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
                          .map((userId) => Chip(
                                label: Text(userId), // Display user ID
                                onDeleted: () {
                                  setState(() {
                                    _invitedUsers.remove(userId);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                          labelText: 'Search username',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    if (_suggestedUsers.isNotEmpty)
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _suggestedUsers.length,
                          itemBuilder: (context, index) {
                            final suggestion = _suggestedUsers[index];
                            return ListTile(
                              title:
                                  Text(suggestion.name), // Display user's name
                              onTap: () {
                                if (!_invitedUsers.contains(suggestion.uid)) {
                                  setState(() {
                                    _invitedUsers.add(suggestion
                                        .uid); // Add user ID to invited list
                                    _searchController.clear();
                                    _suggestedUsers.clear();
                                  });
                                }
                              },
                            );
                          },
                        ),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _submitForm(db),
        label: const Text(
          'Create',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
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
    _searchController.dispose();
    super.dispose();
  }
}
