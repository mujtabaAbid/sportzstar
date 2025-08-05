import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/provider/event_provider.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

import 'all_events_details_screen.dart';

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
    final response = await Provider.of<EventProvider>(
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
  body: _events.isEmpty
      ? const Center(
          child: Text(
            'No Events Found',
            style: TextStyle(color: Colors.white),
          ),
        )
      : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
            return EventCard(event: event);
          },
        ),
);
}
}


class EventModel {
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
      eventId: json['event_id'],
      creatorName: json['event_creator_name'],
      creatorPicture: json['event_creator_picture'],
      hostName: json['event_host_name'],
      hostPicture: json['event_host_picture'],
      title: json['event_title'],
      type: json['event_type'],
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
        margin: const EdgeInsets.only(bottom: 16),
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
              child: event.pictures.isNotEmpty
                  ? Image.network(
                      event.pictures.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                    event.date,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
