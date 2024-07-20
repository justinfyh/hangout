import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/home/event_explore.dart';
import 'package:hangout/screens/home/event_list.dart';
import 'package:hangout/screens/home/event_month.dart';
import 'package:hangout/screens/home/event_tabs.dart';
import 'package:hangout/screens/home/friends_list.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final String uid = user!.uid;

    return StreamProvider<List<Event>?>.value(
      value: DatabaseService(uid: uid).events,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Hangout',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        EventTabs(
                          onTabSelected: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          selectedIndex: selectedIndex,
                        ),
                        const MonthlyEvents(),
                        EventList(
                          events: _filterEvents(
                            Provider.of<List<Event>?>(context) ?? [],
                            selectedIndex,
                            uid,
                          ),
                        ),
                        FriendSection(),
                        ExploreSection(
                            events: Provider.of<List<Event>?>(context) ?? []),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  List<Event> _filterEvents(List<Event> events, int index, String uid) {
    switch (index) {
      case 0:
        return events.where((event) => event.ownerUid == uid).toList();
      case 1:
        return events.where((event) => event.invited.contains(uid)).toList();
      case 2:
        return events.where((event) => !event.isPrivate).toList();
      default:
        return events;
    }
  }
}
