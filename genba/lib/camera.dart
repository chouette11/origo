import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:genba/main.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Camera extends StatefulWidget {
  Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  bool isScanningBusy = false;
  Offset? noseBase;
  double? imageViewportRatio;
  bool isHuman = false;

  @override
  void initState() {

    super.initState();
    getCameras();
  }

  Future<void> getCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![1], ResolutionPreset.low);
    print(controller);

    if (!mounted) {
      return;
    }
    await controller!.initialize();
    await controller!.startImageStream((CameraImage availableImage) {
      // print(isScanningBusy);
      if (!isScanningBusy) {
        scanFace(availableImage);
      }
    });
    setState(() {});
  }

  Widget cameraPreviewWidget() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller!),
        ],
      ),
    );
  }

  void scanFace(CameraImage availableImage) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in availableImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(availableImage.width.toDouble(), availableImage.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationMethods.fromRawValue(cameras![1].sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final InputImageFormat inputImageFormat =
        InputImageFormatMethods.fromRawValue(availableImage.format.raw) ??
            InputImageFormat.NV21;

    final planeData = availableImage.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    List<Face> faces = await faceDetector.processImage(inputImage);
    print(faceDetector.processImage(inputImage));
    print(faces.length);
    if (faces.length != 0) {
      setState(() {
        isHuman = true;
      });
      await controller!.stopImageStream();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isHuman ? MyHome() :
      cameraPreviewWidget(),
    );
  }
}