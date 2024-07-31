import 'package:flutter/material.dart';

import 'home_page.dart';
import 'Notifications.dart';
import 'DangerPage.dart';

class HelplinePage extends StatefulWidget {
  @override
  _HelplinePageState createState() => _HelplinePageState();
}

class _HelplinePageState extends State<HelplinePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Helpline Numbers'),
        backgroundColor: Color(0xFF646ADA),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/background.png', // Your background image path
                fit: BoxFit.cover,
              ),
            ),
            // Animated GIF at the top center
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Image.asset(
                  'assets/cc-unscreen.gif', // Your GIF path
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 180, // Adjust height as needed
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            // Helpline numbers below the GIF
            Padding(
              padding: const EdgeInsets.only(top: 200), // Adjust top padding
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildHelplineCard(
                      title: 'Chennai Corporation',
                      numbers: [
                        '25619206',
                        '25619511',
                        '25384965',
                        '25383694',
                        '25367823',
                        '25387570',
                        '9445477207',
                        '9445477203',
                        '9445477206',
                        '9445477201',
                        '9445477205',
                      ],
                    ),
                    // _buildHelplineCard(
                    //   title: 'Puducherry',
                    //   numbers: ['1077', '1070'],
                    // ),
                    // _buildHelplineCard(
                    //   title: 'Cuddalore',
                    //   numbers: ['107', '04142 220700', '231666'],
                    // ),
                    _buildHelplineCard(
                      title: 'Ambulance',
                      numbers: ['108'],
                    ),
                    _buildHelplineCard(
                      title: 'Police',
                      numbers: ['100'],
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _buildHelplineCard(
      {required String title, required List<String> numbers}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: numbers
                  .map((number) => Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          number,
                          style: TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
