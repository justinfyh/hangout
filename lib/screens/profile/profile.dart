import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/profile/settings.dart';
import 'package:hangout/services/database.dart';
import 'package:hangout/services/storage.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _selectedImagePath;
  String? _downloadUrl;
  bool newImage = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final String uid = user!.uid;

    final userData = Provider.of<UserModel?>(context);

    final DatabaseService db = DatabaseService(uid: uid);
    final StorageService storage = StorageService();

    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final TextEditingController nameController =
        TextEditingController(text: userData.name);
    final TextEditingController emailController =
        TextEditingController(text: userData.email);
    final TextEditingController bioController =
        TextEditingController(text: userData.bio);

// FUNCTIONS
    Future<void> pickImage() async {
      String? imagePath = await storage.pickImage();
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
        });
        newImage = true;
      }
    }

    Future<void> uploadImage() async {
      if (_selectedImagePath != null && newImage == true) {
        String url = await storage.uploadImage(_selectedImagePath!);
        setState(() {
          _downloadUrl = url;
        });
      }
      print(_downloadUrl);
      newImage = false;
    }

// RENDER
    return Scaffold(
      backgroundColor: Colors.white, // Set background color here
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings,
                color: Colors.black), // Add friend icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
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
                          : const AssetImage('assets/images/mascot.png'))
                      as ImageProvider, // Show original profile image
            ),
            TextButton(
              onPressed: pickImage,
              child: const Text('Edit profile image',
                  style: TextStyle(color: Color(0xffFF7A00), fontSize: 11)),
            ),
            Text(
              userData.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userData.bio,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 20),
            _buildTextField('Username', nameController),
            _buildTextField('Email', emailController),
            _buildTextField('Bio', bioController, maxLines: 3),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await uploadImage();
          await db.updateUser(uid, nameController.text, emailController.text,
              bioController.text, _downloadUrl ?? userData.profileImageUrl);
        },
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
