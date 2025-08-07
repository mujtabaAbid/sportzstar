import 'package:flutter/material.dart';
import 'package:sportzstar/screens/eventScreens/all_events_tab.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: false,
      appBar: AppBar(
        title: Text(event.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            event.pictures.isNotEmpty
                ? Image.network(
                  event.pictures.first,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
                : Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.image, size: 50)),
                ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Hosted by: ${event.hostName}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text("Date: ${event.date}"),
            const SizedBox(height: 4),
            Text("Time: ${event.time}"),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16),
                const SizedBox(width: 5),
                Expanded(child: Text(event.location)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Description",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(event.description),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.redAccent,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Request to join', style: TextStyle(color: Colors.white, fontSize: 16)),
              Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Join', style: TextStyle(color: Colors.white, fontSize: 14))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
