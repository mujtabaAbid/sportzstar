import 'package:flutter/material.dart';
import 'package:sportzstar/config/palette.dart';
// import 'package:sportzstar/screens/eventScreens/add_event_screen.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';
import 'package:sportzstar/screens/eventScreens/all_events_tab.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class EventScreen extends StatefulWidget {
  final int? eventIndex;
  const EventScreen({super.key, this.eventIndex});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.eventIndex != null ? widget.eventIndex! : 0,
    );
    _tabController.addListener(() {
      setState(() {});
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            pushNamedNavigate(
              context: context,
              pageName: bottomNavigationBarRoute,
            );
          },
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text('Events', style: TextStyle(color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100), // Height for search + tabs
          child: Column(
            children: [
              // 🔎 Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController, // 🔥 controller added
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search events...",
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // 📌 TabBar
              TabBar(
                controller: _tabController,
                unselectedLabelStyle: const TextStyle(color: Colors.grey),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: const [Tab(text: 'All Events'), Tab(text: 'My Events')],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AllEventsTab(searchQuery: _searchQuery), // 👈 pass query
          MyEventsTab(searchQuery: _searchQuery),
        ],
      ),
      floatingActionButton:
          _tabController.index == 1
              ? Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: FloatingActionButton(
                  heroTag: 'myEventsFAB', // <-- Add unique tag here
                  shape: const CircleBorder(),
                  elevation: 0,
                  tooltip: 'Add Event',
                  backgroundColor: Palette.darkgreen,
                  onPressed: () {
                    pushNamedNavigate(
                      context: context,
                      pageName: addEventScreenRoute,
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
              : null,
    );
  }
}
