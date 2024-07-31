import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import 'Notifications.dart';
import 'DangerPage.dart';

class SafetyCamp extends StatelessWidget {
  final List<Map<String, dynamic>> safetyCamps = [
    {
      'name': 'Anna University',
      'area': 'Kotturpuram',
      'latitude': 13.01093,
      'longitude': 80.23536,
    },
    {
      'name': 'Govt Model Higher Secondary School',
      'area': 'Saidapet',
      'latitude': 13.02300,
      'longitude': 80.22777,
    },
    {
      'name': 'Rajiv Gandhi Government General Hospital Emergency Room',
      'area': 'Poonamalle',
      'latitude': 13.081081,
      'longitude': 80.27676,
    },
    {
      'name': 'MK Mahal',
      'area': 'Shenoy Nagar',
      'latitude': 13.07646,
      'longitude': 80.22762,
    },
    {
      'name': 'Chennai Corporation Government School',
      'area': 'Koyambedu',
      'latitude': 13.07444,
      'longitude': 80.20028,
    },
    {
      'name': 'Government Hospital Tambaram',
      'area': 'Tambaram',
      'latitude': 12.94589,
      'longitude': 80.13435,
    },
    {
      'name': 'Kamarajar school',
      'area': 'Ambattur',
      'latitude': 13.11903,
      'longitude': 80.15485,
    },
    {
      'name': 'KANNARAM PARTY HALL a/c',
      'area': 'OMR',
      'latitude': 12.94031,
      'longitude': 80.23566,
    },
    {
      'name': 'Goverment Hospital',
      'area': 'Thiruvottiyur',
      'latitude': 13.18029,
      'longitude': 80.30473,
    },
    {
      'name': 'Theyagaraya Ngr H School',
      'area': 'T.Nagar',
      'latitude': 13.03975,
      'longitude': 80.23455,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Camps'),
        backgroundColor: Color(0xFF646ADA),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          ListView.builder(
            itemCount: safetyCamps.length,
            itemBuilder: (context, index) {
              final camp = safetyCamps[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      camp['name'],
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          camp['area'],
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () =>
                          _launchMaps(camp['latitude'], camp['longitude']),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //primary: Colors.blue,
                      ),
                      child: Text('Navigate'),
                    ),
                  ),
                ),
              );
            },
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

  Future<void> _launchMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
