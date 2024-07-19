import 'package:flutter/material.dart';

class EventTabs extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  EventTabs({required this.onTabSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildChip('My Events', 0),
          _buildChip('Friend\'s Events', 1),
          _buildChip('Local', 2),
        ],
      ),
    );
  }

  Widget _buildChip(String label, int index) {
    return GestureDetector(
      onTap: () {
        onTabSelected(index);
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
              color: selectedIndex == index ? Colors.white : Colors.black),
        ),
        backgroundColor:
            selectedIndex == index ? Colors.orange : Colors.white24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
