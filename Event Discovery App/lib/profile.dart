import 'login_signup.dart';
import 'package:cen_project/edit_profile_page.dart';
import 'package:cen_project/my_events_page.dart';
import 'package:cen_project/pages/welcome_page.dart';
import 'package:cen_project/saved_events_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget myButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              Icon(icon, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = getUser().username;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: SizedBox(),
        ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.black,
                                child: Text(
                                  username[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Welcome back, $username!',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 75),

                            // Edit Profile section
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Edit Profile Button
                            myButton(
                              context,
                              icon: Icons.edit,
                              label: 'Edit Profile',
                              onPressed: getUser().username != "Guest"
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                            username: username,
                                          ),
                                        ),
                                      );
                                    }
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You must be signed in to edit a profile.',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                            ),

                            const SizedBox(height: 15),

                            // My Events Button
                            myButton(
                              context,
                              icon: Icons.event,
                              label: 'My Events',
                              onPressed: getUser().username != "Guest"
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyEventsPage(),
                                        ),
                                      );
                                    }
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'You must be signed in to view your events.',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                            ),
                            const SizedBox(height: 15),
                            // Saved Events Button
                            myButton(
                              context,
                              icon: Icons.thumb_up,
                              label: 'Custom Saved Events',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SavedEventsPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            myButton(
                              context,
                              icon: Icons.logout,
                              label: 'Sign out',
                              onPressed: () {
                                setUser(
                                  CustomUser("Guest"),
                                ); //Turn user into a guest
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WelcomePage(),
                                  ),
                                );
                              },
                            ),
                          ])
                    ]))));
  }
}
