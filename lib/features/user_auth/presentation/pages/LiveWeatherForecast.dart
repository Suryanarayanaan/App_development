import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WeatherData.dart'; // Import the WeatherData class
import 'home_page.dart';
import 'Notifications.dart';
import 'DangerPage.dart';

class LiveWeatherForecast extends StatefulWidget {
  @override
  _LiveWeatherForecastState createState() => _LiveWeatherForecastState();
}

class _LiveWeatherForecastState extends State<LiveWeatherForecast> {
  WeatherData? _weatherData;
  List<String> _weatherAlerts = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    fetchWeatherAlerts();
  }

  Future<void> fetchWeatherData() async {
    // Add your OpenWeatherMap API key here
    String apiKey = "aa78e1b182018a799fb9efed89d86c80";
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?units=metric&q=chennai&appid=$apiKey";

    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _weatherData = WeatherData.fromJson(jsonData);
      });
    } else {
      // Handle error
      print('Failed to load weather data');
    }
  }

  Future<void> fetchWeatherAlerts() async {
    // Add your OpenWeatherMap API key here
    String apiKey = "aa78e1b182018a799fb9efed89d86c80";
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=chennai&appid=$apiKey";

    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> alerts = jsonData['weather'];
      setState(() {
        _weatherAlerts = alerts
            .map((alert) => alert['description'].toString())
            .toList(); // Extract weather alerts descriptions
      });
    } else {
      // Handle error
      print('Failed to load weather alerts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Weather Forecast'),
        backgroundColor: Color(0xFF646ADA),
        automaticallyImplyLeading: false, // Set app bar color to red
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background.png', // Replace with your asset image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black
                .withOpacity(0), // Add opacity to darken the background image
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _weatherData == null
                          ? CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Weather in ${_weatherData!.name}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Image.network(
                                  'http://openweathermap.org/img/wn/${_weatherData!.icon}.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 20),
                                Table(
                                  border: TableBorder.all(color: Colors.white),
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Temperature',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          '${_weatherData!.temperature}°C',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Feels Like',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          '${_weatherData!.feelsLike}°C',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Condition',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          _weatherData!.condition,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Visibility',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          '${_weatherData!.visibility} km',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Pressure',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          '${_weatherData!.pressure} hPa',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Humidity',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          '${_weatherData!.humidity}%',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Text(
                                          'Wind Speed',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                          '${_weatherData!.windSpeed} km/hr',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 20),
                    _weatherAlerts.isEmpty
                        ? CircularProgressIndicator()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weather Alert:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 0),
                              Column(
                                children: _weatherAlerts
                                    .map((alert) => ListTile(
                                          title: Text(
                                            alert,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white
            .withOpacity(0.8), // Add opacity to bottom navigation bar
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
        onTap: (index) {
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
}
