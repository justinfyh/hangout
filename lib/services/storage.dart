import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart'; // Add this import for generating unique IDs

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid(); // Initialize the UUID generator

  // Upload image to Firebase Storage
  Future<String> uploadImage(String filePath) async {
    File file = File(filePath);
    String uniqueFileName = _uuid.v4(); // Generate a unique file name

    try {
      // Create a reference to the Firebase Storage bucket
      Reference ref = _storage.ref().child('images/$uniqueFileName');

      // Upload the file to Firebase Storage
      await ref.putFile(file);

      // Get the download URL of the uploaded file
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return 'no image';
    }
  }

  // Pick an image from the gallery
  Future<String> pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String downloadURL = await uploadImage(image.path);
      return downloadURL;
    }
    return 'no image';
  }

  // Retrieve image from Firebase Storage
  Future<String> getImageUrl(String fileName) async {
    try {
      String downloadURL =
          await _storage.ref().child('images/$fileName').getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error retrieving image: $e');
      return 'no image';
    }
  }
}
