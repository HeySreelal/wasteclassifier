import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<CameraDescription> _cameras;

  CameraController? controller;

  void setup() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);

    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      scan();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future<void> scan() async {
    try {
      await controller?.startImageStream((CameraImage image) {
        // Do something with the image here.
      });
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Classifier'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: buildCam(),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: const Center(
                  child: Text('Results'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCam() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: Text(
          'Loading',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }
    return CameraPreview(controller!);
  }
}
