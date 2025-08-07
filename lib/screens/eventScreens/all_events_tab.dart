import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/provider/event_provider.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/Loader/loading_widget.dart';

import '../../helper/local_storage.dart';
import 'all_events_details_screen.dart';

class EventModel {
  final int userId;
  final int eventId;
  final String creatorName;
  final String creatorPicture;
  final String hostName;
  final String hostPicture;
  final String title;
  final String type;
  final String date;
  final String time;
  final String location;
  final String description;
  final List<String> pictures;

  EventModel({
    required this.userId,
    required this.eventId,
    required this.creatorName,
    required this.creatorPicture,
    required this.hostName,
    required this.hostPicture,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.pictures,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      userId: json['user_id'],
      eventId: json['event_id'],
      creatorName: json['event_creator_name'],
      creatorPicture: json['event_creator_picture'],
      hostName: json['event_host_name'],
      hostPicture: json['event_host_picture'],
      title: json['event_title'],
      type: json['event_type'] ?? '',
      date: json['event_date'],
      time: json['event_time'],
      location: json['event_location'],
      description: json['event_description'],
      pictures: List<String>.from(json['event_pictures']),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child:
                  event.pictures.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: event.pictures.first,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              height: 200,
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image),
                            ),
                      )
                      : Container(
                        height: 200,
                        color: Colors.grey,
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      ),

              // Image.network(
              //   event.pictures.first,
              //   height: 200,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              // )
              // : Container(
              //   height: 200,
              //   color: Colors.grey,
              //   child: const Center(child: Icon(Icons.image, size: 50)),
              // ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.date,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.location,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(event.hostPicture),
                      ),
                      const SizedBox(width: 10),
                      Text(event.hostName),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class MyEventsTab extends StatefulWidget {
  const MyEventsTab({super.key});

  @override
  State<MyEventsTab> createState() => _MyEventsTabState();
}

class _MyEventsTabState extends State<MyEventsTab> {
  bool _isLoading = false;
  List<EventModel> _myEvents = [];
  Map<String, String> userData = {};

  Future<void> getMyEvents() async {
    setState(() {
      _isLoading = true;
    });
    final user = await getDataFromLocalStorage(name: 'userData');
    final userData = json.decode(user);
    print('object====>>>>${userData['id'].toString()}');
    final userId = userData['id'].toString();
    try {
      final response =
          await Provider.of<EventProvider>(
            context,
            listen: false,
          ).getAllEventsFunction();

      if (response != null && response is List) {
        _myEvents =
            response
                .where((e) => e['user_id'].toString() == userId)
                .map((e) => EventModel.fromJson(e))
                .toList();
      }
    } catch (e) {
      print('Error in getMyEvents: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void deleteEvent(int eventId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = Provider.of<EventProvider>(
        context,
        listen: false,
      ).deleteEventsFunction(eventId: eventId);
      print('deletePost function  success--------->>>>>>$response');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) =>
                  BottomNavigationBarScreen(pageIndex: 2, eventIndex: 1),
        ),
      );
    } catch (e) {
      print('deletePost error function e--------->>>>>>$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _myEvents.isEmpty
              ? const Center(
                child: Text(
                  'My Events Not Found',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _myEvents.length,
                itemBuilder: (context, index) {
                  final event = _myEvents[index];
                  return Stack(
                    children: [
                      EventCard(event: event),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          height: 24,
                          width: 30,
                          color: const Color.fromARGB(110, 63, 63, 63),
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 24,
                            ),
                            onSelected: (String value) {
                              deleteEvent(event.eventId);
                              print(
                                '---delete post function call button---${event.eventId}-----',
                              );
                              // }
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete Post'),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}

class AllEventsTab extends StatefulWidget {
  const AllEventsTab({super.key});

  @override
  State<AllEventsTab> createState() => _AllEventsTabState();
}

class _AllEventsTabState extends State<AllEventsTab> {
  bool _isLoading = false;

  List<EventModel> _events = [];

  Future<void> getAllEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await Provider.of<EventProvider>(
            context,
            listen: false,
          ).getAllEventsFunction();

      if (response != null && response is List) {
        _events = response.map((e) => EventModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error in getAllEvents: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getAllEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // isLoading: _isLoading,
      body:
          _events.isEmpty
              ? const Center(
                child: Text(
                  'No Events Found',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return EventCard(event: event);
                      },
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
    );
  }
}
