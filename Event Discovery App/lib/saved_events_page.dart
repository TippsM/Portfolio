import 'package:cen_project/user_events_view.dart';
import 'package:flutter/material.dart';
import 'login_signup.dart';

class SavedEventsPage extends StatelessWidget {
  const SavedEventsPage({super.key});

  Future<List<Post>?> getLikes() async {
    //https://supabase.com/dashboard/project/tpsfuxvihelfehrlcgvd/editor/29177?schema=public --Source of idea
    final response = await supabase
        .from('likes')
        .select(
            'post_id, posts(id, title, description, location, date, start_time, end_time, tag)')
        .eq('user', getUser().username); //auto joins tables
    if (response.isNotEmpty) {
      List<Post> likes = response.map((item) {
        final post = item['posts'];
        return Post.fromJson({
          'id': post['id'],
          'title': post['title'],
          'description': post['description'],
          'location': post['location'],
          'date': post['date'],
          'start_time': post['start_time'],
          'end_time': post['end_time'],
          'tag': post['tag'],
        });
      }).toList();
      return likes;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Saved Events'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Allow going back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
          children: <Widget>[
            const SizedBox(height: 10),
            const Text(
              'Custom Saved Events', // Title for the saved events
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: getLikes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Hmm, it seems you haven\'t saved any events yet.'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No saved events available.'));
                }

                var savedEvents = snapshot.data!;

                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.8, // Adjusted for a more compact card
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: savedEvents.length,
                    itemBuilder: (context, index) {
                      final event = savedEvents[index];

                      return SizedBox(
                        height:
                            175, // Adjusted height for a smaller, shorter card
                        child: Card(
                          elevation: 5, // Lower elevation for a subtle shadow
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            side: BorderSide(
                                color: const Color.fromARGB(255, 16, 123, 237),
                                width: 2),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(
                                12.0), // Padding inside card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6), // Reduced spacing
                                Text(
                                  event.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 6),

                                // Date and Time Row
                                Row(
                                  children: [
                                    // Calendar icon and date
                                    Icon(Icons.calendar_today,
                                        size: 16, color: Colors.black54),
                                    const SizedBox(width: 6),
                                    Text(event.date,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal)),

                                    // Time range with clock icon
                                    const SizedBox(
                                        width:
                                            10), // Space between date and time
                                    Icon(Icons.access_time,
                                        size: 16, color: Colors.black54),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${event.startTime} - ${event.endTime}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                Text(
                                  event.location,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54),
                                ),
                                const SizedBox(height: 6), // Reduced spacing
                                Text(
                                  event.tag,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
