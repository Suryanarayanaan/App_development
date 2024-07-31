import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'Donate2.dart';
import 'home_page.dart';
import 'Notifications.dart';
import 'DangerPage.dart';

class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  Position? _currentPosition; // Make Position nullable

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  double _calculateDistance(double latitude, double longitude) {
    if (_currentPosition == null) {
      return 0.0; // If current position is null, return 0 as distance
    }

    double distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      latitude,
      longitude,
    );

    return distanceInMeters / 1000; // Convert meters to kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF646ADA),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('requests').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // Sort the donation queue based on distance
            List<DocumentSnapshot> sortedDonations = snapshot.data!.docs;
            sortedDonations.sort((a, b) {
              double distanceA = _calculateDistance(
                  a['latitude'] ?? 0.0, a['longitude'] ?? 0.0);
              double distanceB = _calculateDistance(
                  b['latitude'] ?? 0.0, b['longitude'] ?? 0.0);
              return distanceA.compareTo(distanceB);
            });

            return ListView(
              children: sortedDonations.map((document) {
                Map<String, dynamic> requestData =
                    document.data() as Map<String, dynamic>;

                if (_currentPosition == null) {
                  return SizedBox();
                }

                double distanceInKm = _calculateDistance(
                    requestData['latitude'] ?? 0.0,
                    requestData['longitude'] ?? 0.0);

                Timestamp timestamp = requestData['time'] ?? Timestamp.now();
                DateTime requestTime = timestamp.toDate();
                String timeString =
                    '${requestTime.hour}:${requestTime.minute}:${requestTime.second}';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Donate2(
                              requestData: requestData,
                              documentId: document.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        alignment: Alignment.center,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Italic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Request: ${requestData['name']}',
                                style: TextStyle(
                                  fontFamily: 'times new roman',
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 5),
                                  Text(
                                    'Distance: ${distanceInKm.toStringAsFixed(2)} km',
                                    style: TextStyle(
                                      fontFamily: 'times new roman',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            'Address: ${requestData['address']}',
                            style: TextStyle(
                              fontFamily: 'times new roman',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
        onTap: (index) {
          if (index == 0) {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DangerPage()),
            );
          }
        },
      ),
    );
  }
}
