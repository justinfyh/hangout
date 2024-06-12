import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid(); // Initialize the UUID generator
  String? _selectedImagePath; // Store the selected image path

  // Select an image from the gallery and store its path
  Future<String> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print(image!.path);

    if (image != null) {
      _selectedImagePath = image.path;
    } else {
      _selectedImagePath = null;
    }

    return image.path;
  }

  // Upload the previously selected image to Firebase Storage
  Future<String> uploadImage(String imagePath) async {
    if (imagePath == null) {
      return 'no image';
    }

    print(imagePath);

    File file = File(imagePath!);
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
