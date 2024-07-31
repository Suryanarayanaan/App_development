import 'package:flutter/material.dart';
import 'home_page.dart';
import 'Notifications.dart';
import 'DangerPage.dart';

class GuidelinesPage extends StatefulWidget {
  @override
  _GuidelinesPageState createState() => _GuidelinesPageState();
}

class _GuidelinesPageState extends State<GuidelinesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 2.0)
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
        title: Text('Guidelines'),
        backgroundColor: Color(0xFF646ADA),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: EdgeInsets.all(12.0),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  'assets/com-video-to-gif-converter-unscreen.gif',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 10),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'During Floods:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'Do:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildGuidelines([
                '- Follow government orders and move to safer locations.',
                '- Seek accurate information and avoid rumors.',
                '- Switch off electrical supply and avoid open wires.',
                '- Turn off electrical and gas appliances.',
                '- Carry an emergency kit and inform family of your whereabouts.',
                '- Avoid contact with floodwater and use a pole when walking in water.',
                '- Stay away from power lines and report downed lines.',
                '- Watch out for debris and slippery surfaces.',
                '- Listen to updates via radio or TV.',
              ]),
              SizedBox(height: 10),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'Don\'t:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildGuidelines([
                '- Don\'t walk or swim through flowing water.',
                '- Don\'t drive through flooded areas.',
                '- Don\'t consume food exposed to floodwater.',
                '- Don\'t reconnect power without professional inspection.',
                '- Avoid using electrical equipment on wet surfaces.',
                '- Don\'t attempt rapid removal of basement water.',
              ]),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  'assets/eq.gif',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'During Earthquake:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'Do:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildGuidelines([
                '- Drop, Cover, and Hold On.',
                '- If indoors, stay there; if outdoors, find a clear spot away from buildings, trees, streetlights, and power lines.',
                '- Know your safe spots, such as under a sturdy piece of furniture or against an interior wall.',
                '- Have an earthquake emergency kit ready.',
                '- Listen to updates via radio or TV for emergency information.',
                '- Ensure your home is securely anchored to its foundation.',
                '- Secure heavy furniture, appliances, and objects that might fall.',
                '- Plan and practice your evacuation routes with your family.',
                '- Know the location of utility shut-off valves and switches.',
                '- Conduct drills with your family members for earthquake preparedness.',
              ]),
              SizedBox(height: 10),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  'Don\'t:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              _buildGuidelines([
                "- Don't use elevators.",
                "- Don't run outside.",
              ]),
            ],
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

  Widget _buildGuidelines(List<String> guidelines) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: guidelines
              .map((text) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
