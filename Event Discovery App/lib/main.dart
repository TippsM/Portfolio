import 'dart:async';

import 'package:cen_project/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'event__widget.dart';
import 'map_page.dart';
import 'profile.dart';
import 'src/events.dart' as events;
import 'src/markers.dart';
import 'user_events_view.dart';
import 'login_signup.dart';
import 'logger_settings.dart';

import 'package:intl/intl.dart';

//--------------------------------------------------------------------------
// MyHomePage
// MyHomePage
//--------------------------------------------------------------------------

final getIt = GetIt.instance;

Future<void> main() async {
  // creates two Singletons (one for the TM JSON response, one for map markers) using the get_it package.
  // you can access these using (get_it variable)<(Singleton you wish to get)>().(here are your fields)
  getIt.registerLazySingleton<events.CachedEvents>(() => events.CachedEvents());
  getIt.registerLazySingleton<CachedMarkers>(() => CachedMarkers());

  await Supabase.initialize(
    url: 'https://tpsfuxvihelfehrlcgvd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwc2Z1eHZpaGVsZmVocmxjZ3ZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc5NzAyOTYsImV4cCI6MjA0MzU0NjI5Nn0.5HvO3JQD_cg5BLKoOIGIaMAh9SVpP7YN4fI3qzUsSb0',
  );

  runApp(WelcomeWrapper()); //swap null with something passed in from
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatToDo',
      home: Scaffold(
        body: WelcomePage(),
      ),
    );
  }
}

//--------------------------------------------------------------------------
// Bottom Navigation Bar
// Bottom Navigation Bar
//--------------------------------------------------------------------------

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationExample();
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationExample> {
  int selectedIndex = 0; // home-page

  //----------------------------------------------------------------------
  // list of pages
  // list of pages
  //----------------------------------------------------------------------

  late final List<Widget> _pages;

  @override

  //clean up (like stream.close()) in java

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (getUser().username == "Guest") {
      _pages = [
        const HomePage(), // Home page
        MapPage(), // Map page
        const UserEventView(), // Custom Events page
        WelcomePage(), // Replace Profile with Guest-specific page
      ];
    } else {
      _pages = [
        const HomePage(), // home page
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage())),
        MapPage(), // map page
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapViewPage())),
        const UserEventView(),
        const ProfilePage(), //profile page
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          //guest functionality added
          if (getUser().username == 'Guest' && (value == 2)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Guests cannot access this page! Please sign-in to view!"),
              ),
            );
          } else if (getUser().username == 'Guest' && (value == 3)) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          } else {
            setState(() {
              selectedIndex = value;
            });
          }
        },
        //----------------------------------------------------------------------
        // Buttons in navigation bar
        //----------------------------------------------------------------------
        indicatorColor: const Color.fromARGB(255, 188, 225, 255),

        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Custom Events',
          ),
          NavigationDestination(
            icon: Icon(getUser().username == 'Guest'
                ? Icons.login
                : Icons.account_circle_rounded),
            label: getUser().username == 'Guest' ? 'Sign In' : 'Profile',
          ),
        ],
      ),

      // display different pages based on the selectedIndex
      body: _pages[selectedIndex],
    );
  }
}

late Future<events.Response> _events; //make events global

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

Future<events.Response> getSearchTerms() async {
  return getIt<events.CachedEvents>().fetchEventsFromDeviceLocation();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _events = getSearchTerms(); // Fetch events when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'WhatToDo',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchButton(),
            SizedBox(height: 20),
            // Use FutureBuilder to fetch and display event data
            FutureBuilder<events.Response>(
              future: _events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data?.embedded?.events == null) {
                  return const Center(child: Text('No events found.'));
                } else {
                  // Data fetched, display the list of EventWidgets
                  List<events.Event> eventsList =
                      snapshot.data!.embedded!.events;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: eventsList.length,
                      itemBuilder: (context, index) {
                        var result = eventsList[index];

                        logger.i(eventsList.length);

                        final rawDateTime = result.dates?.start?.dateTime;
                        final formattedDate = rawDateTime != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(rawDateTime).toLocal())
                            : 'No Date';

                        final formattedTime = rawDateTime != null
                            ? DateFormat('hh:mm a')
                                .format(DateTime.parse(rawDateTime).toLocal())
                            : 'No Time';

                        // String classificationDisplay = '';
                        // if (result.classifications != null &&
                        //     result.classifications!.isNotEmpty) {
                        //   var classification = result.classifications![
                        //       0]; // Access the first classification
                        //   classificationDisplay = '${classification.toJson()}';
                        // }

                        return EventWidget(
                          title: result.name!,
                          imageUrl: '${result.images?[0].url}',
                          date: formattedDate,
                          time: formattedTime,
                          distance: result.distance.toString(),
                          url: result.url ?? 'No link',
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<events.Response>(
      future: _events,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate:
                    CustomSearchDelegate(snapshot.data as events.Response),
              );
            },
            backgroundColor: Color.fromARGB(255, 145, 204, 253),
            child: const Icon(Icons.search),
          );
        } else {
          return FloatingActionButton(
            onPressed: () {
              unawaited(Fluttertoast.showToast(
                msg: "Still fetching event data",
                toastLength: Toast.LENGTH_SHORT,
              ));
            },
            backgroundColor: Color.fromARGB(255, 145, 204, 253),
            child: const Icon(Icons.search_off),
          );
        }
      },
    );
  }
}

//--------------------------------------------------------------------------
// SearchBar
//--------------------------------------------------------------------------

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Discover..',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 85, 142, 227)),
          ),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------
// SearchDelegate for SearchBar
//--------------------------------------------------------------------------

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate(this.eventList);

  final events.Response eventList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<events.Event> myQuery = [];

    if (eventList.embedded?.events != null) {
      for (var event in eventList.embedded!.events) {
        if (event.name != null) {
          if (event.name!.toLowerCase().contains(query.toLowerCase())) {
            myQuery.add(event);
          }
        }
      }
    }

    return ListView.builder(
      itemCount: myQuery.length,
      itemBuilder: (context, index) {
        var result = myQuery[index];

        final rawDateTime = result.dates?.start?.dateTime;

        final formattedDate = rawDateTime != null
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(rawDateTime).toLocal())
            : 'No date available';

        final formattedTime = rawDateTime != null
            ? DateFormat('hh:mm a')
                .format(DateTime.parse(rawDateTime).toLocal())
            : 'No time available';

        // String classificationDisplay = '';
        // if (result.classifications != null &&
        //     result.classifications!.isNotEmpty) {
        //   var classification =
        //       result.classifications![0]; // Access the first classification
        //   classificationDisplay = '${classification.toJson()}';
        // }

        return EventWidget(
          title: result.name!,
          imageUrl: '${result.images?[0].url}',
          date: formattedDate,
          time: formattedTime,
          distance: result.distance.toString(),
          url: result.url ?? 'No link',
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> myQuery = [];

    if (eventList.embedded?.events != null) {
      for (var event in eventList.embedded!.events) {
        if (event.name != null) {
          if (event.name!.toLowerCase().contains(query.toLowerCase())) {
            myQuery.add(event.name!);
          }
        }
      }
    }

    return ListView.builder(
      itemCount: myQuery.length,
      itemBuilder: (context, index) {
        var result = myQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result;
            showResults(context);
          },
        );
      },
    );
  }
}
