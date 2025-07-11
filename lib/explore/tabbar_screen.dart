import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/explore/add_event_screen.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update FAB visibility
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        title: const Text('Events'),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Events'),
            Tab(text: 'My Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllEventsTab(),
          MyEventsTab(),
        ],
      ),
     floatingActionButton: _tabController.index == 1
    ? FloatingActionButton(
        heroTag: 'myEventsFAB', // <-- Add unique tag here
        shape: const CircleBorder(),
        elevation: 0,
        tooltip: 'Add Event',
        backgroundColor: Palette.darkgreen,
        onPressed: () {
         pushNamedNavigate(context: context, pageName: addEventScreenRoute);
        },
        child: const Icon(Icons.add, color: Colors.white),
      )
    : null,

    );
  }
}

class AllEventsTab extends StatelessWidget {
  const AllEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("All Events List"));
  }
}

class MyEventsTab extends StatelessWidget {
  const MyEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("My Events List"));
  }
}