import 'package:flutter/material.dart';
import 'homepage.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.grey,
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
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                    height:
                        10), // Add some spacing between the icon and the checkboxes
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Checkbox(
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Text("Dark Mode"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Checkbox(
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Text("Notification"),
                  ],
                ),
                const SizedBox(
                    height: 10), // Add some spacing between the checkbox rows
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Checkbox(
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Text("Sound"),
                  ],
                ),
                const SizedBox(
                    height: 10), // Add some spacing between the checkbox rows

                Container(
                  color: Color.fromARGB(192, 195, 203, 211), //changed color
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Student Number",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Parent's Contact Number",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Guardian's Contact Number",
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(currentUser: existingAccount)),
                    );*/
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
