import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:hangout/services/storage.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _bioController = TextEditingController();

  String? _selectedImagePath;
  String? _downloadUrl;
  bool newImage = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final String uid = user!.uid;

    final userData = Provider.of<UserModel?>(context);

    final DatabaseService db = DatabaseService(uid: uid);

    final StorageService _storage = StorageService();

    final TextEditingController _nameController =
        TextEditingController(text: userData!.name);
    final TextEditingController _emailController =
        TextEditingController(text: userData.email);

    Future<void> _pickImage() async {
      String? imagePath = await _storage.pickImage();
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
        });
        newImage = true;
      }
    }

    Future<void> _uploadImage() async {
      if (_selectedImagePath != null && newImage == true) {
        String url = await _storage.uploadImage(_selectedImagePath!);
        setState(() {
          _downloadUrl = url;
        });
      }
      newImage = false;
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set background color here
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _selectedImagePath != null
                  ? FileImage(
                      File(_selectedImagePath!)) // Show preview of new image
                  : (userData.profileImageUrl != null &&
                              userData.profileImageUrl.isNotEmpty
                          ? NetworkImage(
                              userData.profileImageUrl) // Load network image
                          : AssetImage('assets/images/mascot.png'))
                      as ImageProvider, // Show original profile image
            ),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Edit profile image'),
            ),
            const SizedBox(height: 20),
            // _buildTextField('Name', _nameController),
            _buildTextField('Username', _nameController),
            _buildTextField('Email', _emailController),
            // _buildLinkField(),
            _buildTextField('Bio', _bioController, maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _uploadImage();
                await db.updateUser(
                    uid,
                    _nameController.text,
                    _emailController.text,
                    _downloadUrl ?? userData.profileImageUrl);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildLinkField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Links'),
          const SizedBox(height: 8),
          _buildTextField(
              'Instagram', TextEditingController(text: 'instagram.com/helena')),
          _buildTextField(
              'Facebook', TextEditingController(text: 'facebook.com/helena')),
          _buildTextField(
              'Other Link', TextEditingController(text: 'link.to/helena')),
          TextButton(
            onPressed: () {
              // Implement add link functionality
            },
            child: const Text('+ Add link'),
          ),
        ],
      ),
    );
  }
}
