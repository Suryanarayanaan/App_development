import 'package:flutter/material.dart';
import 'home_page.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF646ADA),
        title: Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/background.png'), // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/np.gif', // Replace with your GIF path
                  width: 200, // Adjust width as needed
                  height: 200, // Adjust height as needed
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWarningPoint(
                        'The cyclone is approaching the coast and is moving at a high speed. Please stay indoors and avoid going near water bodies. Contact us if there are any discrepancies.'),
                    _buildWarningPoint(
                        'Heavy rainfall is expected in the next 24 hours. Please be prepared and stay safe.'),
                    _buildWarningPoint(
                        'Strong winds are forecasted in coastal areas. Secure loose objects and take necessary precautions.'),
                    // Add more warning points as needed
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning,
            color: Colors.red,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
