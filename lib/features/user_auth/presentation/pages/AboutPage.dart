import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Color(0xFF646ADA), // Set app bar background color
        elevation: 0, // Remove app bar elevation
      ),
      // extendBodyBehindAppBar: true, // Extend body behind app bar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/wc-removebg-preview.png', // Your image asset path

                    // fit: BoxFit.cover,
                    // width: double
                    //     .infinity, // Set image width to match screen width
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Welcome to our innovative disaster management app designed to empower communities in times of crisis. Our app serves as a comprehensive platform where users can access critical resources, receive real-time updates, and contribute to collective response efforts.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Times New Roman', // Set font style
                      color: Colors.black, // Set text color
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'What Can You Do?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman', // Set font style
                      color: Colors.black, // Set text color
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildListItem(
                    'Request Assistance',
                    'Reach out for urgent help by submitting requests for essential supplies like food, water, and medical aid directly through the app.',
                  ),
                  _buildListItem(
                    'Donate',
                    'Make a difference by donating resources to those in need. Your contributions help support vulnerable communities during challenging times.',
                  ),
                  _buildListItem(
                    'Find Missing Persons',
                    'Join us in the search for missing individuals by submitting details and keeping an eye out for alerts within the app. Together, we can reunite families and ensure the safety of all community members.',
                  ),
                  _buildListItem(
                    'Lookup Safety Camps',
                    'Discover nearby safety camps and shelters where you can seek refuge in emergencies. Access location information and contact details for quick assistance.',
                  ),
                  _buildListItem(
                    'Get Live Weather Updates',
                    'Stay informed about changing weather conditions with our live updates feature. Receive accurate forecasts to help you prepare and stay safe.',
                  ),
                  _buildListItem(
                    'Receive Alert Notifications',
                    'Be instantly notified about critical alerts and updates related to disasters and emergencies. Stay informed and take necessary precautions to protect yourself and your loved ones.',
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Join Us in Making a Difference',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman', // Set font style
                      color: Colors.black, // Set text color
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'With our app, you have the power to make a positive impact during challenging times. Together, let\'s build a resilient and supportive community where everyone can thrive, even in the face of adversity.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Times New Roman', // Set font style
                      color: Colors.black, // Set text color
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman', // Set font style
            color: Colors.black, // Set text color
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          description,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Times New Roman', // Set font style
            color: Colors.black, // Set text color
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutPage(),
  ));
}
