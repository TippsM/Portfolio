import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // for sharing feature
import 'package:url_launcher/url_launcher_string.dart'; // for url clicking

class EventWidget extends StatefulWidget {
  const EventWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.distance,
    required this.url,
  });

  final String date;
  final String distance;
  final String imageUrl;
  final String time;
  final String title;
  final String url;

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  // Variable to track if the event is liked or not
  bool isLiked = false;

  _shareContent(String? url) {
    Share.share(url!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Left: Image with clickable heart icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.imageUrl,
                      height: 100.0, // Adjust height
                      width: 100.0, // Adjust width
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.0, // Distance from top
                    right: 8.0, // Distance from right
                    child: GestureDetector(
                      onTap: () {
                        //add it to likes in database
                        setState(() {
                          isLiked = !isLiked; // Toggle liked state
                        });
                      },
                      child: Icon(
                        Icons.favorite, // Solid heart icon
                        color: isLiked
                            ? Colors.red
                            : Colors.white, // Red if liked, white if not
                        size: 24.0, // Icon size
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked; // Toggle liked state
                        });
                      },
                      child: Icon(
                        Icons.favorite_border, // Heart border
                        color:
                            isLiked ? Colors.red : Colors.grey, // Border color
                        size: 24.0, // Border icon size
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.0), // Space between image and details

              // Right: Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.0),

                    // Date and Time
                    Row(
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 12.0), // Space between date and time
                        Icon(
                          Icons.access_time,
                          size: 16.0,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          widget.time,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    SizedBox(height: 6.0),
                    // Distance
                    Text(
                      '${widget.distance} miles away',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(children: [
                      ElevatedButton.icon(
                        onPressed: widget.url != "No link"
                            ? () async {
                                try {
                                  await launchUrlString(widget.url);
                                } catch (err) {
                                  debugPrint('Error going to source');
                                }
                              }
                            : () {
                                // Show SnackBar when the URL is "No link"
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No link available'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                        icon: widget.url != "No link"
                            ? Icon(Icons.link)
                            : Icon(Icons.link_off),
                        label: SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0), // Remove any padding
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      ElevatedButton.icon(
                          onPressed: widget.url != "No link"
                              ? () => _shareContent(widget.url)
                              : () {
                                  // Show SnackBar when the URL is "No link"
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Sharing unavailable for this post'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                          icon: widget.url != "No link"
                              ? const Icon(Icons.share_sharp)
                              : const Icon(Icons.block),
                          label: const Text(""))
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
