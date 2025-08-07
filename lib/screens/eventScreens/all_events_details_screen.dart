import 'package:flutter/material.dart';
import 'package:sportzstar/screens/eventScreens/all_events_tab.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

// void joinEvent() async {
//     try {
//       final response = await Provider.of<EventProvider>(
//         context,
//         listen: false,
//       ).joinEventFun(eventId: event.eventId.toString());
//       final responseData = json.decode(response.body);
//       if (response.statusCode == 201) {
//         print('joinevent response success -------->$responseData');
//         alertNotification(
//           context: context,
//           message: responseData['message'],
//           messageType: AlertMessageType.success,
//         );
//       } else {
//         print('joinevent response error  -------->$responseData');
//       }
//     } catch (e) {
//       print('joinevent response error  e-------->$e');
//     }
//   }
  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      isLoading: false,
      appBar: AppBar(
        title: Text(widget.event.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            widget.event.pictures.isNotEmpty
                ? Image.network(
                  widget.event.pictures.first,
                  width: double.infinity,
                  height: 350,
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
              capitalizeEachWord(widget.event.title),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Hosted by: ${capitalizeEachWord(widget.event.hostName)}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),

            const SizedBox(height: 8),
            Text(
              "Date: ${widget.event.date}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              "Time: ${widget.event.time}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16,  color: Colors.white),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.event.location,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Description",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.event.description,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
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
              Text(
                'Request to join',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Join',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
