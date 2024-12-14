import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_signup.dart';
import 'logger_settings.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<Map<String, dynamic>> userEvents = []; // List to store event info
  Map<String, dynamic>? selectedEvent; // Selected event info

  @override
  void initState() {
    super.initState();
    _fetchUserEvents(); // Get user's events when the page loads
  }

  Future<void> _fetchUserEvents() async {
    try {
      String username = getUser().username;

      final response = await Supabase.instance.client
          .from('posts')
          .select('*') // Select all event details
          .eq('username', username);

      setState(() {
        userEvents = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      logger.e('Exception while fetching events', error: e);
    }
  }

  // Delete event logic
  Future<void> _deleteEvent(Map<String, dynamic> event) async {
    try {
      String eventId = event['id'].toString();

      final response = await Supabase.instance.client
          .from('posts')
          .delete()
          .eq('id', eventId);

      setState(() {
        userEvents.removeWhere((e) => e['id'] == event['id']);
        selectedEvent = null; // Reset selected event
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Event deleted successfully!'),
      ));
    } catch (e) {
      logger.e('Exception while deleting event', error: e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Event NOT deleted!'),
      ));
    }
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return 'Not set';
    }

    DateTime? dateTime = DateTime.tryParse(timeString);
    if (dateTime == null) {
      return 'Invalid time';
    }

    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    String username = getUser().username;
    String userInitials = username.isNotEmpty
        ? username[0].toUpperCase()
        : 'U'; // Default to 'U' if username is empty

    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User icon with initials
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      child: Text(
                        userInitials,
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      username,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown menu to select an event
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<Map<String, dynamic>>(
                  value: selectedEvent,
                  hint: const Text('Select an event'),
                  items: [
                    const DropdownMenuItem<Map<String, dynamic>>(
                      value: {'title': 'Select an event'},
                      child: Text('Select an event'),
                    ),
                    ...userEvents.map((event) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: event,
                        child: Text(event['title']),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedEvent = value;
                    });
                  },
                  isExpanded: true,
                  elevation: 8,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blue, width: 2.0))),
                ),
              ),

              const SizedBox(height: 20),

              // Display event details when selected
              if (selectedEvent != null &&
                  selectedEvent!['title'] != 'Select an event') ...[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    side: BorderSide(
                      color: Colors
                          .blue, // Border color (set this to your desired color)
                      width: 2,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section
                        Row(
                          children: [
                            Expanded(
                              // Expands to take remaining space
                              child: Text(
                                selectedEvent!['title'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                softWrap: true, // Ensures text wraps
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Description Section
                        Row(
                          children: [
                            Icon(Icons.description,
                                size: 20), // Description icon
                            const SizedBox(width: 8),
                            Expanded(
                              // Expands to take remaining space
                              child: Text(
                                '${selectedEvent!['description'] ?? 'Not provided'}',
                                style: const TextStyle(fontSize: 15),
                                softWrap: true, // Ensures text wraps
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Date Section
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 20), // Date icon
                            const SizedBox(width: 8),
                            Expanded(
                              // Expands to take remaining space
                              child: Text(
                                'Date: ${selectedEvent!['date'] ?? 'Not provided'}',
                                style: const TextStyle(fontSize: 15),
                                softWrap: true, // Ensures text wraps
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Time Section
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 20), // Time icon
                            const SizedBox(width: 8),
                            Expanded(
                              // Expands to take remaining space
                              child: Text(
                                '${selectedEvent!['start_time']} to ${selectedEvent!['end_time']}',
                                style: const TextStyle(fontSize: 15),
                                softWrap: true, // Ensures text wraps
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Location Section
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20), // Location icon
                            const SizedBox(width: 8),
                            Expanded(
                              // Expands to take remaining space
                              child: Text(
                                '${selectedEvent!['location'] ?? 'Not specified'}',
                                style: const TextStyle(fontSize: 15),
                                softWrap: true, // Ensures text wraps
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Delete event button
                Center(
                  child: ElevatedButton(
                    onPressed: () async => await _deleteEvent(selectedEvent!),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 205, 28, 28),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Delete Event'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
