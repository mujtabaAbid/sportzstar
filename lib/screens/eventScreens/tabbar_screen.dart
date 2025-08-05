import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
// import 'package:sportzstar/screens/eventScreens/add_event_screen.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/eventScreens/all_events_tab.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

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
    return MainLayoutWidget(
      isLoading: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text('Events', style: TextStyle(color: Colors.white),),
        bottom: TabBar(
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
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
    ? Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: FloatingActionButton(
        
          heroTag: 'myEventsFAB', // <-- Add unique tag here
          shape: const CircleBorder(),
          elevation: 0,
          tooltip: 'Add Event',
          backgroundColor: Palette.darkgreen,
          onPressed: () {
           pushNamedNavigate(context: context, pageName: addEventScreenRoute);
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
    )
    : null,

    );
  }
}



class MyEventsTab extends StatelessWidget {
  const MyEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("My Events List"));
  }
}