import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportzstar/screens/eventScreens/all_events_tab.dart';
import 'package:sportzstar/screens/eventScreens/full_image_screen.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
                widget.event.pictures.isNotEmpty
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
                            widget.event.pictures.map((imageUrl) {
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
                                            child: CircularProgressIndicator(),
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
                            }).toList(),
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
                      "Date: ${widget.event.date}",
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
                      "Time: ${widget.event.time}",
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
                        capitalizeEachWord(widget.event.location),
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
                  capitalizeEachWord(widget.event.description),
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
                                  imageUrl: widget.event.hostPicture,
                                ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(widget.event.hostPicture),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.event.hostName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (widget.event.guestList.isNotEmpty) ...[
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
                        widget.event.guestList.map((guest) {
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
                                              imageUrl: guest.picture,
                                            ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      guest.picture,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  guest.name,
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
                if (widget.event.joiners.isNotEmpty) ...[
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
                        widget.event.joiners.map((join) {
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
                                              imageUrl: join.picture,
                                            ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(join.picture),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  join.name,
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
