import 'package:flutter/material.dart';

class MonthlyEvents extends StatelessWidget {
  const MonthlyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('This Month',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('July 2024', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
