import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/wrapper.dart';
import 'package:hangout/services/auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserIdentity?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: _buildTheme(Brightness.light),
        home: const DefaultTabController(length: 5, child: Wrapper()),
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      primaryColor: const Color(0xffFF7A00),
      scaffoldBackgroundColor: Colors.white,
      // Define button and text field styles here
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffFF7A00), // Button color
          textStyle: const TextStyle(color: Colors.white), // Button text style
          // padding: EdgeInsets.symmetric(
          //     vertical: 12, horizontal: 24), // Button padding
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xffFF7A00),
          textStyle:
              const TextStyle(color: Colors.white), // Text button text style
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(), // Text field border
        hintStyle: TextStyle(color: Colors.orange),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Color(0xffFF7A00), width: 2.0), // Focused border color
        ),
        // Add more text field styles as needed
      ),
    );
  }
}
