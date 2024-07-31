import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MissingPersonDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Persons'),
        backgroundColor: Color(0xFF646ADA),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('missing_persons')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                // Extract data from each document
                String name = document['name'];
                int age = document['age'];
                String gender = document['gender'];
                String lastContact = document['last_contact'];
                String relationship = document['relationship'];
                String address = document['address'];
                String complaintContact = document['complaint_contact'];
                String reportedBy = document['reported_by'];
                String imageUrl = document['image_url'];

                // Display data along with the image in a Card
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('Name: $name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Age: $age\nGender: $gender\nLast Contact: $lastContact\n'
                            'Relationship: $relationship\nAddress: $address\n'
                            'Complaint Contact: $complaintContact\nReported By: $reportedBy'),
                      ],
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        );
                      },
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 60,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.person),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return Center(child: Text('No data found'));
        },
      ),
    );
  }
}
