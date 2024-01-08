import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDarkModeEnabled = false;
  bool isNotificationEnabled = false;
  bool isSoundEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: true,
          backgroundColor: Colors.grey,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.settings,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      value: isDarkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value;
                        });
                      },
                      title: const Text("Dark Mode"),
                    ),
                    SwitchListTile(
                      value: isNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          isNotificationEnabled = value;
                        });
                      },
                      title: const Text("Notification"),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      value: isSoundEnabled,
                      onChanged: (value) {
                        setState(() {
                          isSoundEnabled = value;
                        });
                      },
                      title: const Text("Sound"),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
