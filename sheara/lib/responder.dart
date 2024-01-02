import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResponderPage(),
    );
  }
}

class ResponderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 176, 53, 0),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
            color: Color.fromARGB(255, 199, 199, 199),
          ),
        ],
      ),
      body: Center(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.notification_important,
                color: Colors.red,
              ),
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.message_rounded,
                color: Colors.red,
              ),
            ),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.contact_phone_rounded,
                color: Colors.red,
              ),
            ),
            label: "Contact",
          ),
        ],
      ),
    );
  }
}
