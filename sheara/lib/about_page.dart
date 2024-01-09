import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Developers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 194, 88, 23),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'MEET THE TEAM',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTeamMember('assets/hadjie.png', 'HADJIE BERNALES JR',
                'Scrum Master/Project Manager'),
            _buildTeamMember('assets/maxinne.png', 'MAXINNE GWEN CAHILIG',
                'Documentation Specialist'),
            _buildTeamMember(
                'assets/cate.png', 'CATE GELLAI MUCAS', 'Frontend Developer'),
            _buildTeamMember(
                'assets/kyle.png', 'JOHN KYLE JUNSAY', 'Backend Developer'),
            _buildTeamMember('assets/jezia.png', 'JEZIA BETHANY SABALILAG',
                'Frontend Developer'),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'If you have any questions or feedback, please feel free to reach out to us at:',
            ),
            Text(
              'Email: contact@healthemergencyapp.com',
            ),
            Text(
              'Phone: +123-456-7890',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String imagePath, String name, String role) {
    return Row(
      children: [
        Image.asset(imagePath,
            width: 80, height: 80), // Adjust width and height as needed
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(role),
          ],
        ),
      ],
    );
  }
}
