import 'login_signup.dart';
import 'package:postgrest/src/types.dart';
import 'custom_events.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'logger_settings.dart';
import 'package:intl/intl.dart';


final List<String> dropDownItems = <String>['All', 'Food', 'Event', 'Business'];

class Post {
  Post(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.tag});

  factory Post.fromJson(Map<String, dynamic> json) {

    String startTimeString = json['start_time'];
    String endTimeString = json['end_time'];   

    DateFormat inputFormat = DateFormat("HH:mm:ss");
    DateFormat outputFormat = DateFormat("hh:mm a");

    String displayStartTime = outputFormat.format(inputFormat.parse(startTimeString));
    String displayEndTime = outputFormat.format(inputFormat.parse(endTimeString));

    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      startTime: displayStartTime,
      endTime: displayEndTime,
      location: json['location'],
      tag: json['tag'],
    );
  }

  final String date;
  final String description;
  final String endTime;
  final int id;
  final String location;
  final String startTime;
  //final Image? picture;
  final String tag;

  final String title;
}

//Retrieves posts from database
Future<List<Post>> getPosts(String? filter) async {
  PostgrestList response;
  if (filter == "All") {
    response = await supabase.from('posts').select();
  } else {
    response = await supabase.from('posts').select().eq('tag', filter!);
  }
  final posts = response;

  return posts.map((post) => Post.fromJson(post)).toList();
}

class UserEventView extends StatefulWidget {
  const UserEventView({super.key});

  @override
  State<UserEventView> createState() => _UserEventViewState();
}

//
class _UserEventViewState extends State<UserEventView> {
  String dropDownValue = dropDownItems.first;
  bool? hasCheckedAllLikes = false;
  bool? _isLiked;
  final Map<int, bool?> _likedStates = {};
  List<Post> _posts = [];
  late Future<List<Post>> _postsFuture = Future.value(_posts);
  String _tag = dropDownItems.first;

  // var likedList = getLikes();

  @override
  void initState() {
    super.initState();
    getPostsList();
    checkLikedStates(_posts);
  }

  //gets the list of post to avoid repeated API calls
  Future<void> getPostsList() async {
    final posts = await getPosts(_tag); // your function to fetch posts
    setState(() {
      _posts = posts; // Update the local posts list
      _postsFuture = Future.value(posts); // Update the Future with new data
    });
  }

  void setPostsList(Future<List<Post>> newList) {
    _postsFuture = newList;
  }

  Future<void> likePost(Post post) async {
    int likeID;
    do {
      likeID = Random().nextInt(2000000000);
      var isUnique = await supabase.from('posts').select('id').eq('id', likeID);
      if (isUnique.isEmpty) {
        break;
      }
    } while (true);
    await supabase.from('likes').insert(
        {'like_id': likeID, 'post_id': post.id, 'user': getUser().username});
    logger.i("Added ${post.id} to likes");

    setState(() {
      _isLiked = true;
    });
  }

  Future<void> unlikePost(Post post) async {
    await supabase
        .from('likes')
        .delete()
        .eq('post_id', post.id)
        .eq('user', getUser().username);
    logger.i("Removed ${post.id} from likes");
    setState(() {
      _isLiked = false;
    });
  }

//Checks if a user has liked a particular post
  Future<void> checkLikedStates(List<Post> posts) async {
    final response = await supabase
        .from('likes')
        .select('post_id')
        .eq('user', getUser().username);
    logger.i(response);

    List<int> postIds = [];
    // Check if response is a list
    for (var item in response) {
      // Access the post_id from each item
      if (item['post_id'] != null) {
        postIds.add(item['post_id']); // Add the post_id to the list
      }
    }
    for (var post in posts) {
      if (postIds.contains(post.id)) {
        _likedStates[post.id] = true;
      } else {
        _likedStates[post.id] = false;
      }
    }
    // hasCheckedAllLikes = true;
  }

//checks if a user has liked a specific post. Used to update like button appearance
  Future<bool> isLiked(Post post) async {
    bool liked;
    final query = (await supabase
        .from('likes')
        .select()
        .eq('post_id', post.id)
        .eq('user', getUser().username));
    if (query.isEmpty) {
      liked = false;
    } else {
      liked = true;
    }
    setState(() {
      _isLiked = liked;
    });
    return liked;
  }

  void setFilter(String? filter) {
    setState(() {
      dropDownValue = filter!;
      _tag = filter;
      setPostsList(getPosts(_tag));
    });
  }

  //---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Events'),
        leading: SizedBox(),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            icon: Icon(Icons.filter_list_rounded),
            value: dropDownValue,
            onChanged: (String? value) {
              setFilter(value);
            },
            items: dropDownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No posts available.'));
                }

                var posts = snapshot.data!;
                if (hasCheckedAllLikes == false) {
                  checkLikedStates(posts);
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final checkLiked = _likedStates[post.id] ?? false;

                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 16, 123, 237),
                          width: 2,
                        ),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              post.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16),
                                    SizedBox(width: 5),
                                    Text(post.date),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16),
                                    SizedBox(width: 5),
                                    Text("${post.startTime} - ${post.endTime}"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(post.location),
                            SizedBox(height: 10),
                            Text(post.tag),
                            SizedBox(height: 15),
                            ElevatedButton.icon(
                              onPressed: (getUser().username != "Guest")
                                  ? () async {
                                      if (checkLiked) {
                                        await unlikePost(post);
                                      } else {
                                        await likePost(post);
                                      }
                                      bool newLikedStatus = await isLiked(post);
                                      setState(() {
                                        _likedStates[post.id] = newLikedStatus;
                                      });
                                    }
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'You must be signed in to like this event.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                              icon: Icon(
                                checkLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_alt_outlined,
                                color: checkLiked ? Colors.blue : Colors.black,
                              ),
                              label: SizedBox.shrink(),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    EdgeInsets.all(0), // Remove any padding
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          //SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomEventsPage();
                  });
              setState(() {
                getPostsList();
              });
            },
            style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text(
              "Create Event",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
