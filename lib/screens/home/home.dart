import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/home/event_explore.dart';
import 'package:hangout/screens/home/event_list.dart';
import 'package:hangout/screens/home/event_month.dart';
import 'package:hangout/screens/home/event_tabs.dart';
import 'package:hangout/screens/home/friends_list.dart';
import 'package:hangout/services/auth.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final userData = Provider.of<UserModel?>(context);
    final String uid = user!.uid;

    return StreamProvider<List<Event>?>.value(
      value: DatabaseService(uid: uid).events,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              elevation: 0,
              // leading: IconButton(
              //   icon: const Icon(Icons.menu, color: Colors.black),
              //   onPressed: () {},
              // ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Hangout', style: TextStyle(color: Colors.black)),
              ),
              actions: [
                // CircleAvatar(
                //   radius: 15,
                //   backgroundImage:
                //       NetworkImage(userData?.profileImageUrl ?? ''),
                //   backgroundColor: Colors.grey[300],
                // ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SingleChildScrollView(
                  child: Column(
                    children: [
                      EventTabs(),
                      MonthlyEvents(),
                      EventList(),
                      FriendSection(),
                      ExploreSection(),
                      Center(
                        child: FilledButton(
                          onPressed: () async {
                            await _auth.signOut();
                          },
                          child: const Text('Log Out'),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
