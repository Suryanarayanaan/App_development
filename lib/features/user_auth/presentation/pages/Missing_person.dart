import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'MissingPersonDetailsPage.dart';
import 'home_page.dart';
import 'Notifications.dart';
import 'DangerPage.dart';

class MissingPersonPage extends StatefulWidget {
  @override
  _MissingPersonPageState createState() => _MissingPersonPageState();
}

class _MissingPersonPageState extends State<MissingPersonPage> {
  String? _name;
  int? _age;
  String? _gender;
  String? _lastContact;
  String? _relationship;
  String? _address;
  String? _complaintContact;
  String? _reportedBy;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Missing Person'),
        backgroundColor: Color(0xFF646ADA),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _age = int.tryParse(value);
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      _gender = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Contact',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    onChanged: (value) {
                      _lastContact = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Relationship with the Person',
                      prefixIcon: Icon(Icons.people),
                    ),
                    onChanged: (value) {
                      _relationship = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    onChanged: (value) {
                      _address = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Complaint Contact',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    onChanged: (value) {
                      _complaintContact = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Reported By',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      _reportedBy = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Upload Image'),
                  ),
                  _imageFile == null
                      ? Text('No image selected.')
                      : Image.file(_imageFile!),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitReport,
                    child: Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to missing persons details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MissingPersonDetailsPage(),
                        ),
                      );

                      // Clear form fields
                      _clearForm();
                    },
                    child: Text('View Missing Persons'),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _submitReport() async {
    // Validate form fields
    if (_name == null ||
        _name!.isEmpty ||
        _age == null ||
        _gender == null ||
        _lastContact == null ||
        _relationship == null ||
        _address == null ||
        _complaintContact == null ||
        _reportedBy == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload an image.')),
      );
      return;
    }

    try {
      // Upload image to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('missing_persons')
          .child(
              _complaintContact!) // Assuming _complaintContact is the document ID
          .child(
              'image.jpg'); // Change 'image.jpg' to a unique filename if necessary

      final UploadTask uploadTask = storageRef.putFile(_imageFile!);
      final TaskSnapshot downloadUrl =
          await uploadTask.whenComplete(() => null);
      final String imageUrl = await downloadUrl.ref.getDownloadURL();

      // Store report in Firestore
      await FirebaseFirestore.instance
          .collection('missing_persons')
          .doc(_complaintContact)
          .set({
        'name': _name,
        'age': _age,
        'gender': _gender,
        'last_contact': _lastContact,
        'relationship': _relationship,
        'address': _address,
        'complaint_contact': _complaintContact,
        'reported_by': _reportedBy,
        'image_url': imageUrl,
        'reported_at': DateTime.now(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Missing person report submitted successfully.')),
      );

      // Clear form fields
      _clearForm();
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  void _uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _clearForm() {
    setState(() {
      _name = '';
      _age = null;
      _gender = '';
      _lastContact = '';
      _relationship = '';
      _address = '';
      _complaintContact = '';
      _reportedBy = '';
      _imageFile = null;
    });
  }
}
