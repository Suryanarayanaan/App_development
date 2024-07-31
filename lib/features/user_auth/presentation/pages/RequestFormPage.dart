import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:geolocator/geolocator.dart';
import 'DangerPage.dart';
import 'Notifications.dart';

class RequestFormPage extends StatefulWidget {
  @override
  _RequestFormPageState createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  String? _selectedHelp;
  String? _type;
  int? _quantity;
  String? _name;
  String? _mobileNumber;
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Form'),
        backgroundColor: Color(0xFF646ADA),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white, // Change this color as needed
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white, // Change this color as needed
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _mobileNumber = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white, // Change this color as needed
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _address = value;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedHelp,
                  hint: Text('Select Help Needed'),
                  items: [
                    'Food',
                    'Medicines',
                    'Clothes',
                    'Sanitary Products',
                    'Baby Products',
                    'Boat and Rescue',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedHelp = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Type',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.white, // Change this color as needed
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _type = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.white, // Change this color as needed
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _quantity = int.tryParse(value);
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Validate and submit form
                    _validateAndSubmit();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
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
          // Handle bottom navigation bar item tap
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  Future<void> _storeRequest() async {
    try {
      String documentId = _mobileNumber ?? '';
      Position position = await _determinePosition();

      await FirebaseFirestore.instance
          .collection('requests')
          .doc(documentId)
          .set({
        'help_needed': _selectedHelp,
        'quantity_required': _quantity,
        'name': _name,
        'mobile_number': _mobileNumber,
        'address': _address,
        'type': _type,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request submitted successfully.'),
      ));

      setState(() {
        _selectedHelp = null;
        _type = null;
        _quantity = null;
        _name = null;
        _mobileNumber = null;
        _address = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ));
    }
  }

  void _validateAndSubmit() {
    if (_selectedHelp == null ||
        _quantity == null ||
        _name == null ||
        _name!.isEmpty ||
        _mobileNumber == null ||
        _mobileNumber!.isEmpty ||
        _address == null ||
        _address!.isEmpty ||
        _type == null ||
        _type!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields.'),
      ));
    } else {
      _storeRequest();
    }
  }
}
