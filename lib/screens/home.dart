import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wasteclassifier/classifier/classifier.dart';
import 'package:image/image.dart' as img;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = 'model_unquant.tflite';

class HomeScreenState extends State<HomeScreen> {
  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  late Classifier _classifier;

  late List<CameraDescription> _cameras;

  CameraController? controller;

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

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

  int count = 0;

  Future<void> scan() async {
    try {
      await controller?.startImageStream((CameraImage image) {
        count++;

        if (count % 15 != 0) {
          return;
        }

        count = 0;

        final img.Image convertedImage = img.Image.fromBytes(
          image.planes[0].bytesPerRow,
          image.height,
          image.planes[0].bytes,
          format: img.Format.bgra,
        );

        final results = _classifier.predict(convertedImage);

        log("Results: $results");
      });
    } catch (e, st) {
      log(e.toString(), stackTrace: st);
    }
  }

  @override
  void initState() {
    setup();
    _loadClassifier();
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
