import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class VideoPage extends StatefulWidget {
  final CameraDescription camera;

  VideoPage({required this.camera});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late CameraController controller;
  late String videoPath;
  late Database db; // Database instance
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    initializeDatabase();
  }

  Future<void> initializeCamera() async {
    controller = CameraController(widget.camera, ResolutionPreset.medium);
    await controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> initializeDatabase() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'videos_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE videos(id INTEGER PRIMARY KEY, path TEXT)',
        );
      },
      version: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Camera',
          style: TextStyle(
            color: const Color.fromARGB(
                255, 255, 255, 255), // Change the text color here
          ),
        ),
        backgroundColor: Color.fromARGB(
            255, 182, 140, 42), // Change the background color here
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _recordVideo,
            style: ElevatedButton.styleFrom(
              primary: isRecording ? Colors.red : Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.camera,
                size: 40,
                color: isRecording ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _recordVideo() async {
    try {
      if (!controller.value.isRecordingVideo) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        videoPath = join(appDir.path, '${DateTime.now()}.mp4');

        await controller.startVideoRecording();

        setState(() {
          isRecording = true;
        });
      } else {
        await controller.stopVideoRecording();

        // Save video path to the database
        await saveVideoPathToDatabase();

        // Handle the recording stopped logic
        _onRecordingStopped();
      }
    } catch (e) {
      print('Error recording video: $e');
    }
  }

  void _onRecordingStopped() {
    setState(() {
      videoPath = '';
      isRecording = false;
    });
  }

  Future<void> saveVideoPathToDatabase() async {
    await db.insert(
      'videos',
      {'path': videoPath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    db.close(); // Close the database when disposing the widget
    super.dispose();
  }
}
