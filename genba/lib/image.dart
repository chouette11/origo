
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void FaceDetectorView() async {
  final pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  final setImage = File(pickFile!.path);
  final inputImage = InputImage.fromFile(setImage);
  final faceDetector = GoogleMlKit.vision.faceDetector();
  List<Face> faces = await faceDetector.processImage(inputImage);
  print(faceDetector.processImage(inputImage));
  print(faces.length);
}
