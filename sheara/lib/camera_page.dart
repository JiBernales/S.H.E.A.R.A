import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final camera = await initializeCamera();
  runApp(MyApp(camera: camera));
}

Future<CameraDescription> initializeCamera() async {
  final cameras = await availableCameras();
  return cameras.first;
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(camera: camera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  XFile? capturedImage; // Variable to store the captured image file

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Camera',
          style: TextStyle(
            color: Color.fromARGB(
                255, 255, 255, 255), // Change the text color here
          ),
        ),
        backgroundColor: Color.fromARGB(
            255, 27, 175, 133), // Change the background color here
      ),
      body: Column(
        children: [
          Expanded(
            child: capturedImage == null
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Image.file(
                    File(capturedImage!.path)), // Display captured image
          ),
          SizedBox(height: 16),
          // Shutter Button
          GestureDetector(
            onTap: () {
              _captureImage();
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.camera,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _captureImage() async {
    if (!controller.value.isInitialized) {
      return;
    }

    try {
      XFile file = await controller.takePicture();

      // Save the captured image file to device storage
      await saveImageToStorage(file);

      //Update UI to display the captured image
      if (mounted) {
        setState(() {
          capturedImage = file;
        });
      }
    } catch (e) {
      print('Error capturing image: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing image. Please try again.'),
        ),
      );
    }
  }

  Future<void> saveImageToStorage(XFile imageFile) async {
    try {
      //get the directory for saving files
      final appDir = await getApplicationDocumentsDirectory();
      // construct the file path
      const filePath = '{appDir.path/my_captured_image.png}';
      //copy the captured image to the desired location
      await File(imageFile.path).copy(filePath);
      print('Image saved to: $filePath');
    } catch (e) {
      print('Error saving image to storage: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
