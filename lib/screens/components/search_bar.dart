import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            TextStyle(color: Colors.grey[600]), // Lighter grey hint text color
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.search,
              color:
                  Colors.grey[600]), // Match the icon color with the hint text
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal:
                16.0), // Adjust padding to make the text field look cleaner
        filled: true,
        fillColor: Colors.grey[200], // Light grey background for the text field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              30.0), // Rounder corners like Instagram's search bar
          borderSide: BorderSide.none, // Remove border line
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
