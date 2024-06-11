import 'package:flutter/material.dart';
import 'package:hangout/screens/authenticate/Login.dart';
import 'package:hangout/screens/authenticate/register.dart';
import 'package:hangout/screens/home/home.dart';

class Tabber extends StatelessWidget {
  const Tabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          Home(),
          Login(),
          Register(),
          // ProfileTab(),
          // SettingsTab(),
        ],
      ),
      bottomNavigationBar: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.home), text: 'Home'),
          Tab(icon: Icon(Icons.person), text: 'Friends'),
          Tab(icon: Icon(Icons.settings), text: 'Settings'),
        ],
      ),
    );
  }
}
