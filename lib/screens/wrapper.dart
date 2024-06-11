import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/authenticate/authenticate.dart';
import 'package:hangout/screens/tabber.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserModel?>.value(
              value: DatabaseService(uid: user.uid).userData,
              initialData: null,
              catchError: (_, __) => null),
          StreamProvider<List<Event>?>.value(
              value: DatabaseService(uid: user.uid).events,
              initialData: null,
              catchError: (_, __) => [])
        ],
        child: const Tabber(),
      );
    }
  }
}
