import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Guidelines.dart';
import 'Missing_person.dart';
import 'RequestFormPage.dart';
import 'HelplinePage.dart';
import 'Analysis.dart';
import 'LiveWeatherForecast.dart';
import 'Donate.dart';
import 'Notifications.dart';
import 'AboutPage.dart';
import 'DangerPage.dart';
import 'SafetyCamp.dart';

class HomePage extends StatefulWidget {
  final String? username;
  final String? contact;

  const HomePage({Key? key, this.username, this.contact}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _username = ''; // Initialize with default value
  late String _contact = ''; // Initialize with default value

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch user data when the page initializes
  }

  Future<void> _getUserData() async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;

      // Retrieve user data from Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .get();

      // Update state with retrieved values
      setState(() {
        _username = userData['name'];
        _contact = userData['mobile'];
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF646ADA), // Change app bar color to green
        title: Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    _username ??
                        'Loading...', // Display 'Loading...' until data is fetched
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _contact ??
                        'Loading...', // Display 'Loading...' until data is fetched
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                // Navigate to about page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
                Fluttertoast.showToast(msg: 'Logged out successfully');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/flood-gif-bg-unscreen.gif',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height *
                  0.3, // Adjust height to screen height
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.37, // Adjust spacing
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 40, // Add spacing between grid items
                  mainAxisSpacing: 20, // Add spacing between grid items
                  children: [
                    buildGridItem(Icons.accessibility, 'Request'),
                    buildGridItem(Icons.volunteer_activism, 'Donate'),
                    buildGridItem(Icons.safety_divider, 'Safety Camps'),
                    buildGridItem(Icons.phone, 'Helpline Numbers'),
                    buildGridItem(Icons.checklist, 'Do and Don\'ts'),
                    buildGridItem(Icons.assessment, 'Past Disaster Analysis'),
                    buildGridItem(Icons.cloud, 'Live Weather Forecast'),
                    buildGridItem(Icons.person_search, 'Missing Persons'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous),
            label: 'Danger',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            // Navigate to the Notification Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 2) {
            // Navigate to the Danger Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DangerPage()),
            );
          }
        },
      ),
    );
  }

  Widget buildGridItem(IconData icon, String label) {
    return Card(
      elevation: 7, // Add elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(30), // Add border radius for rounded corners
      ),
      child: InkWell(
        onTap: () {
          // Handle grid item tap
          if (label == 'Request') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestFormPage()),
            );
          } else if (label == 'Helpline Numbers') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelplinePage()),
            );
          } else if (label == 'Do and Don\'ts') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuidelinesPage()),
            );
          } else if (label == 'Past Disaster Analysis') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Analysis()),
            );
          } else if (label == 'Missing Persons') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MissingPersonPage()),
            );
          } else if (label == 'Live Weather Forecast') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LiveWeatherForecast()),
            );
          } else if (label == 'Donate') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Donate()),
            );
          } else if (label == 'Safety Camps') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafetyCamp()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40, // Adjust icon size
                color: Colors.blue.shade800, // Set dark blue color
              ),
              SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(fontSize: 12), // Adjust label font size
              ),
            ],
          ),
        ),
      ),
    );
  }
}
