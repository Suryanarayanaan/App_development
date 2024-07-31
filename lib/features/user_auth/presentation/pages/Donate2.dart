import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'map_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Donate2 extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final String documentId; // New property to receive document ID

  const Donate2({Key? key, required this.requestData, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF646ADA),
        title: Text('Request Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Add your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    _buildTableRow('Name:', '${requestData['name']}'),
                    _buildTableRow('Address:', '${requestData['address']}'),
                    _buildTableRow(
                        'Mobile Number:', '${requestData['mobile_number']}'),
                    _buildTableRow(
                        'Help Needed:', '${requestData['help_needed']}'),
                    _buildTableRow('Type:', '${requestData['type']}'),
                    _buildTableRow('Quantity Required',
                        '${requestData['quantity_required']}'),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showDialog(context);
                  },
                  child: Text('Donate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You!'),
          content: Text(
              'Your donation is greatly appreciated. Thank you for your generosity!'),
          actions: <Widget>[
            TextButton(
              child: Text('Navigate'),
              onPressed: () {
                double latitude = requestData['latitude'];
                double longitude = requestData['longitude'];
                MapUtils.openMap(latitude, longitude);
                // Remove the donated request from Firestore
                FirebaseFirestore.instance
                    .collection('requests')
                    .doc(documentId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
