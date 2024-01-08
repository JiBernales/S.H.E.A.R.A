import 'package:flutter/material.dart';
import '../database/accountsDatabase.dart';
import '../database/signalsDatabase.dart';
import '../model/account.dart';

class UserProfile extends StatefulWidget {
  final account currentUser;

  const UserProfile({required this.currentUser});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late int studentNumber;
  late String username;
  late String password;
  late String parentContact;
  late String guardianContact;

  late TextEditingController studentNumberController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController parentContactController;
  late TextEditingController guardianContactController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    studentNumber = widget.currentUser.idNumber ?? 0;
    username = widget.currentUser.dispname;
    password = widget.currentUser.password;
    parentContact = '';
    guardianContact = '';

    studentNumberController =
        TextEditingController(text: studentNumber.toString());
    usernameController = TextEditingController(text: username);
    passwordController = TextEditingController(text: password);
    parentContactController = TextEditingController(text: parentContact);
    guardianContactController = TextEditingController(text: guardianContact);
  }

  Widget _buildDisplayField(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Existing information display
              Container(
                color: Color.fromARGB(192, 195, 203, 211),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    isEditing
                        ? _buildTextField(
                            "Student Number", studentNumberController)
                        : _buildDisplayField(
                            "Student Number:", studentNumber.toString()),
                    isEditing
                        ? _buildTextField("Username", usernameController)
                        : _buildDisplayField("Username:", username),
                    isEditing
                        ? _buildTextField("Password", passwordController)
                        : _buildDisplayField("Password:", password),
                    isEditing
                        ? _buildTextField(
                            "Parent's Contact", parentContactController)
                        : _buildDisplayField(
                            "Parent's Contact:", parentContact),
                    isEditing
                        ? _buildTextField(
                            "Guardian's Contact", guardianContactController)
                        : _buildDisplayField(
                            "Guardian's Contact:", guardianContact),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(isEditing ? "Save" : "Edit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
