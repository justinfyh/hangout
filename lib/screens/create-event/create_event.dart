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

  final StorageService _storage = StorageService();

  String? _selectedImagePath;
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
  }

  Future<void> _selectDateTime(BuildContext context) async {
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
        setState(() {
          _dateTimeController.text =
              DateFormat('MMM dd, yyyy HH:mm').format(combined);
        });
      }
    }
  }

  Future<void> _pickImage() async {
    String? imagePath = await _storage.pickImage();
    if (imagePath != null) {
      setState(() {
        _selectedImagePath = imagePath;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImagePath != null) {
      String url = await _storage.uploadImage(_selectedImagePath!);
      setState(() {
        _downloadUrl = url;
      });
    }
  }

  Future<void> _clearForm() async {
    _eventNameController.clear();
    _dateTimeController.text =
        DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now());
    _locationController.clear();
    _detailsController.clear();
    setState(() {
      _selectedImagePath = null;
      _downloadUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    Provider.of<UserModel?>(context);
    final String uid = user!.uid;
    final DatabaseService db = DatabaseService(uid: uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add end time'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Repeat event'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('UTC+12'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                    labelText: 'Location', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Who can see it?', border: OutlineInputBorder()),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Upload the image first
                    await _uploadImage();
                    // Then create the event with the download URL
                    db.createEvent(
                      _eventNameController.text,
                      _dateTimeController.text,
                      _locationController.text,
                      _detailsController.text,
                      uid,
                      _downloadUrl ?? '',
                    );

                    _clearForm();
                    DefaultTabController.of(context).animateTo(0);
                  }
                },
                child: const Text('Create event'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
