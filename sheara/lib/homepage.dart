import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:sheara/camera_page.dart';
import 'package:sheara/userprofile.dart';
import 'package:sheara/microphone_page.dart';
import 'package:sheara/video_page.dart';
import '../database/accountsDatabase.dart';
import '../database/signalsDatabase.dart';
import '../model/account.dart';
import '../model/helpSignal.dart';
import 'about_page.dart';
import 'guide.dart';
import 'send_sos.dart';
import 'settings.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  @override
  final account currentUser;
  HomePage({required this.currentUser});

  HomePageState createState() => HomePageState();
}

//late helpSignalsDatabase helpSignalsDB;

class HomePageState extends State<HomePage> {
  late MapController _mapController;
  late LocationData _currentLocation;
  double _zoomLevel = 16;
  late Location _location;
  late String urgency;

  @override
  void initState() {
    super.initState();
    //helpSignalsDB = helpSignalsDatabase.instance;
    _mapController = MapController();
    _location = Location();
    _currentLocation =
        LocationData.fromMap({'latitude': 10.6419, 'longitude': 122.2310});

    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }

  void _zoomIn() {
    double currentZoom = _mapController.zoom;
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        currentZoom + 0.5);
  }

  void _zoomOut() {
    double currentZoom = _mapController.zoom;
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        currentZoom - 0.5);
  }

  void _centerOnMarker() {
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        _zoomLevel);
  }

  void _toggleHelpStatus() async {
    bool newHelpStatus = !widget.currentUser.needsHelp;
    widget.currentUser.needsHelp = newHelpStatus;

    try {
      await accountsDatabase.instance.update(widget.currentUser);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Help status updated!'),
      ));
    } catch (e) {
      print('Error updating help status: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update help status. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String uColor1 = widget.currentUser.favColor;
    String remove1 = 'Color(';
    String uColor2 = uColor1.replaceAll(remove1, '');
    String remove2 = ')';
    String navColor = uColor2.replaceAll(remove2, '');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(navColor)),
        centerTitle: true,
        title: Text(widget
            .currentUser.dispname), // Replace with the user's actual username
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfile(currentUser: widget.currentUser),
              ),
            );
          },
        ),

        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              } else if (value == 'guide') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuidePage()),
                );
              } else if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                PopupMenuItem(
                  value: 'guide',
                  child: Text('Guide'),
                ),
                PopupMenuItem(
                  value: 'about',
                  child: Text('About the Developer'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/home_bg.png', // Replace with your image file path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SquareButton(
                        imageAsset: 'assets/camera.png',
                        onTap: () async {
                          CameraDescription firstCamera =
                              await initializeCamera();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraScreen(camera: firstCamera),
                            ),
                          );
                        },
                      ),
                      SquareButton(
                        imageAsset: 'assets/video.png',
                        onTap: () async {
                          CameraDescription firstCamera =
                              await initializeCamera();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VideoPage(camera: firstCamera)),
                          );
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onLongPress: () {
                      showColorCircles(context);
                    },
                    child: Transform.scale(
                      scale: 1.5,
                      child: Image.asset(
                        'assets/snake_button.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SquareButton(
                        imageAsset: 'assets/microphone.png',
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoiceRecorderPage()),
                          );
                        },
                      ),
                      SquareButton(imageAsset: 'assets/chat.png'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showColorCircles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleButton(
                color: Color.fromARGB(255, 222, 11, 11),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Critical',
                onTap: () => navigateToSendSOSPage(context, 'Critical'),
              ),
              // Add other colored buttons here with their respective logic
              CircleButton(
                color: Color.fromARGB(255, 226, 105, 5),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'High',
                onTap: () => navigateToSendSOSPage(context, 'High'),
              ),
              CircleButton(
                color: Color.fromARGB(255, 224, 192, 8),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Medium',
                onTap: () => navigateToSendSOSPage(context, 'Medium'),
              ),
              CircleButton(
                color: Color.fromARGB(255, 59, 200, 8),
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Low',
                onTap: () => navigateToSendSOSPage(context, 'Low'),
              ),
              CircleButton(
                color: Colors.blue,
                onToggleHelpStatus: _toggleHelpStatus,
                buttonText: 'Advisory',
                onTap: () => navigateToSendSOSPage(context, 'Advisory'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> navigateToSendSOSPage(BuildContext context, String level) async {
    Location location = Location();
    LocationData? userLocation = await location.getLocation();

    helpSignal newSignal = helpSignal(
      victimName: widget.currentUser.dispname,
      urgencyLevel: level,
      lastSeenLatitude: userLocation.latitude,
      lastSeenLongitude: userLocation.longitude,
      lastSeenTime: DateTime.now(),
    );
    try {
      await helpSignalsDatabase.instance.create(newSignal);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Help status updated!')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendSOSPage(currentUser: widget.currentUser),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Sorry, something went wrong while asking for help. Error: $e')));
    }
  }
}

class SquareButton extends StatelessWidget {
  final String imageAsset;
  final Function()? onTap; // Add this line

  SquareButton({required this.imageAsset, this.onTap}); // Add this line

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Add this line
      child: Center(
        child: Image.asset(
          imageAsset,
          width: 100, // Adjust the width as needed
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final Function()? onTap;
  final Function()? onToggleHelpStatus;

  CircleButton(
      {required this.color,
      this.onTap,
      this.onToggleHelpStatus,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        onToggleHelpStatus?.call();
      },
      child: Container(
          width: 72,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(2),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Text font size
                ),
              ),
            ),
          )),
    );
  }
}
