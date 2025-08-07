import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportzstar/config/palette.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/screens/eventScreens/add_guest_screen.dart';
import 'package:sportzstar/screens/eventScreens/all_events_tab.dart';
import 'package:sportzstar/screens/eventScreens/full_image_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../helper/basic_enum.dart';
import '../../helper/local_storage.dart';
import '../../provider/event_provider.dart';
import '../../widgets/alerts/alert_notification_widget.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;
  Map<String, dynamic> eventData = {};
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    getEventData(eventId: widget.event.eventId);
  }

  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<void> getEventData({required int eventId}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await getDataFromLocalStorage(name: 'userData');
      userData = json.decode(data);

      final response = await Provider.of<EventProvider>(
        context,
        listen: false,
      ).getEventById(eventId: eventId);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(
          'getEventData response success --and ${userData['id']}------>$responseData',
        );

        eventData.addAll(responseData);
      } else {
        print('getEventData response error  -------->$responseData');
      }
    } catch (e) {
      print('getEventData response error  e-------->$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void joinEvent() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await Provider.of<EventProvider>(
        context,
        listen: false,
      ).joinEventFun(eventId: widget.event.eventId.toString());
      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        print('joinevent response success -------->$responseData');
        alertNotification(
          context: context,
          message: responseData['message'],
          messageType: AlertMessageType.success,
        );
      } else {
        print('joinevent response error  -------->$responseData');
        alertNotification(
          context: context,
          message: responseData['error'],
          messageType: AlertMessageType.error,
        );
      }
    } catch (e) {
      print('joinevent response error  e-------->$e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (eventData.isEmpty) {
      return const MainLayoutWidget(
        isLoading: true,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return MainLayoutWidget(
      isLoading: _isLoading,
      appBar: AppBar(
        title: Text(
          eventData['event_title'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: const Color.fromARGB(29, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event image
                eventData['event_pictures'].isNotEmpty
                    ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 350,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          autoPlay: true,
                        ),
                        items:
                            (eventData['event_pictures'] as List<dynamic>)
                                .map<Widget>((imageUrl) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              height: 350,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              height: 350,
                                              color: Colors.grey,
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            ),
                                      );
                                    },
                                  );
                                })
                                .toList(),
                      ),
                    )
                    : Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey,
                      child: const Center(child: Icon(Icons.image, size: 50)),
                    ),
                const SizedBox(height: 16),
                Text(
                  capitalizeEachWord(eventData['event_title']),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Created by: ${capitalizeEachWord(eventData['event_creator_name'])}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Date: ${eventData['event_date']}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Time: ${eventData['event_time']}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        capitalizeEachWord(eventData['event_location']),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Description",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  capitalizeEachWord(eventData['event_description']),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 6),
                const Text(
                  "Hosts",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FullImageScreen(
                                  imageUrl: eventData['event_host_picture'],
                                ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          eventData['event_host_picture'],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      eventData['event_host_name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                if (eventData['guestList'].isNotEmpty) ...[
                  const Text(
                    "Guests",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children:
                        (eventData['guestList'] as List<dynamic>).map<Widget>((
                          guest,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => FullImageScreen(
                                              imageUrl: guest['guest_picture'],
                                            ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      guest['guest_picture'],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  guest['guest_name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ],
                const SizedBox(height: 8),

                if (eventData['joiners'].isNotEmpty) ...[
                  const Text(
                    "Joiners",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children:
                        (eventData['joiners'] as List<dynamic>).map<Widget>((
                          joiners,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => FullImageScreen(
                                              imageUrl:
                                                  joiners['joiner_picture'],
                                            ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      joiners['joiner_picture'],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  joiners['joiner_name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ],

                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 80, 80, 80),
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userData['id'] != eventData['user_id']
                    ? 'Request to join'
                    : 'Add Special Guests',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  userData['id'] != eventData['user_id']
                      ? joinEvent()
                      : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AddGuestScreen(
                                eventId: eventData['event_id'].toString(),
                              ),
                        ),
                      );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Palette.facebookColor,
                  ),
                ),
                child: Text(
                  userData['id'] != eventData['user_id'] ? 'Join' : 'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      // : null,
    );
  }
}
