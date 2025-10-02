import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/provider/event_provider.dart';
import 'package:sportzstar/screens/bottom_navigation_bar.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/Loader/loading_widget.dart';
import 'package:intl/intl.dart';

import '../../helper/local_storage.dart';
import 'event_details_screen.dart';

class GuestModel {
  final String name;
  final String picture;

  GuestModel({required this.name, required this.picture});

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(name: json['guest_name'], picture: json['guest_picture']);
  }
}

class JoinerModel {
  final int id;
  final String name;
  final String picture;

  JoinerModel({required this.id, required this.name, required this.picture});

  factory JoinerModel.fromJson(Map<String, dynamic> json) {
    return JoinerModel(
      id: json['joiner_id'],
      name: json['joiner_name'],
      picture: json['joiner_picture'],
    );
  }
}

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
  final List<GuestModel> guestList;
  final List<JoinerModel> joiners;

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
    required this.guestList,
    required this.joiners,
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
      guestList:
          (json['guestList'] as List)
              .map((e) => GuestModel.fromJson(e))
              .toList(),
      joiners:
          (json['joiners'] as List)
              .map((e) => JoinerModel.fromJson(e))
              .toList(),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    String formatDate(String dateString) {
  try {
    DateTime date;

    try {
      date = DateTime.parse(dateString);
    } catch (_) {
      date = DateFormat("MMMM dd, yyyy").parse(dateString);
    }

    return DateFormat('MM-dd-yyyy').format(date);
  } catch (e) {
    return dateString; // fallback if parsing fails
  }
}

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
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(event.date),
                    // event.date,
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
          ],
        ),
      ),
    );
  }
}

class MyEventsTab extends StatefulWidget {
  final String searchQuery;
  const MyEventsTab({super.key, required this.searchQuery});

  @override
  State<MyEventsTab> createState() => _MyEventsTabState();
}

class _MyEventsTabState extends State<MyEventsTab> {
  bool _isLoading = false;
  List<EventModel> _myEvents = [];
  Map<String, String> userData = {};
 
  DateTime _parseDate(String dateString) {
  try {
    return DateTime.parse(dateString); // ISO
  } catch (_) {
    try {
      return DateFormat("MMMM dd, yyyy").parse(dateString); // September 30, 2025
    } catch (e) {
      return DateTime(1900); // fallback (very old so it goes bottom)
    }
  }
}
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
                 _myEvents.sort((a, b) {
        DateTime dateA = _parseDate(a.date);
        DateTime dateB = _parseDate(b.date);
        return dateB.compareTo(dateA); // recent → top
      });
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
    getMyEvents();
    super.initState();
  }
  
   String formatDate(String dateString) {
  try {
    DateTime date;
    try {
      date = DateTime.parse(dateString);
    } catch (_) {
      date = DateFormat("MMMM dd, yyyy").parse(dateString);
    }
    return DateFormat('MM-dd-yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}

  @override
  Widget build(BuildContext context) {
       final filteredEvents = widget.searchQuery.isEmpty
    ? _myEvents
    : _myEvents.where((event) {
        final search = widget.searchQuery.toLowerCase();

        return event.title.toLowerCase().contains(search) ||   // 🔥 title
               event.location.toLowerCase().contains(search) || // 🔥 location
               event.hostName.toLowerCase().contains(search) || // 🔥 host
               formatDate(event.date).toLowerCase().contains(search); // 🔥 formatted date
      }).toList();
    // final filteredEvents =
    //     _myEvents.where((event) {
    //       final search = widget.searchQuery.toLowerCase();
    //       return event.location.toLowerCase().contains(search) ||
    //           event.date.toLowerCase().contains(search);
    //     }).toList();
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
              : filteredEvents.isEmpty
              ? const Center(
                child: Text(
                  'No Events Search',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredEvents.length,
                // itemCount: _myEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
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
  final String searchQuery;
  const AllEventsTab({super.key, required this.searchQuery});

  @override
  State<AllEventsTab> createState() => _AllEventsTabState();
}

class _AllEventsTabState extends State<AllEventsTab> {
  bool _isLoading = false;

  List<EventModel> _events = [];
  
  DateTime _parseDate(String dateString) {
  try {
    return DateTime.parse(dateString); // ISO
  } catch (_) {
    try {
      return DateFormat("MMMM dd, yyyy").parse(dateString); // September 30, 2025
    } catch (e) {
      return DateTime(1900); // fallback (very old so it goes bottom)
    }
  }
}

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
         _events.sort((a, b) {
        DateTime dateA = _parseDate(a.date);
        DateTime dateB = _parseDate(b.date);
        return dateB.compareTo(dateA); // recent → top
      });
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
   String formatDate(String dateString) {
  try {
    DateTime date;
    try {
      date = DateTime.parse(dateString);
    } catch (_) {
      date = DateFormat("MMMM dd, yyyy").parse(dateString);
    }
    return DateFormat('MM-dd-yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}

  @override
  Widget build(BuildContext context) {
   final filteredEvents = widget.searchQuery.isEmpty
    ? _events
    : _events.where((event) {
        final search = widget.searchQuery.toLowerCase();

        return event.title.toLowerCase().contains(search) ||   // 🔥 title
               event.location.toLowerCase().contains(search) || // 🔥 location
               event.hostName.toLowerCase().contains(search) || // 🔥 host
               formatDate(event.date).toLowerCase().contains(search); // 🔥 formatted date
      }).toList();

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
              : filteredEvents.isEmpty
              ? const Center(
                child: Text(
                  'No Events Search',
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
                      itemCount: filteredEvents.length,
                      // itemCount: _events.length,
                      itemBuilder: (context, index) {
                        // final event = _events[index];
                        final event = filteredEvents[index];
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
