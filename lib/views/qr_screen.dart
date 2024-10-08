import 'package:flutter/material.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/widgets/custom_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

import '../widgets/qr_screen_dialog.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  double _zoomValue = 1.0;
  bool cameraFacing = true; // Initial camera facing
  bool flashOn = false; // Initial flash state
  bool isCameraOn = true;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      // Only show the dialog if the scanned QR code is different from the previous one
      if (scanData.code != null) {
        controller.pauseCamera(); // Pause the camera to avoid scanning again

        setState(() {
          qrText = scanData.code;
          isCameraOn = false;
        });

        // Show the QR scan dialog with the scanned text
        _showQRScanDialog(qrText!);
      }
    });
  }

  void resumeCamera(QRViewController controller) {
    controller.resumeCamera();
  }

  void _showQRScanDialog(String qrText) async {
    // giving a small amount of vibration.
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 300); // Vibrate for 500ms
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRScanDialog(
          qrImagePath: 'Assets/icons8-qr-100.png',
          qrText: qrText,
          controller: controller!,
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    controller!.stopCamera();
    setState(() {
      isCameraOn = false;
    });
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        final result = await Scan.parse(image.path);

        if (result != null && result.isNotEmpty) {
          _showQRScanDialog(result);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No QR code found in the image.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning QR code: $e')),
        );
      }
    }
  }

  void _toggleFlash() {
    setState(() {
      flashOn = !flashOn;
      controller?.toggleFlash();
    });
  }

  void _toggleCamera() {
    setState(() {
      cameraFacing = !cameraFacing;
    });
    controller?.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.backgroundColor(context),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Card(
              color: Appcolor.cardColor(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _pickImageFromGallery,
                      icon: Icon(Icons.perm_media,
                          size: 24, color: Appcolor.yellowText(context)),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _toggleFlash,
                      icon: Icon(
                        flashOn ? Icons.flashlight_on : Icons.flashlight_off,
                        size: 24,
                        color: Appcolor.yellowText(context),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _toggleCamera,
                      icon: Icon(Icons.cameraswitch_rounded,
                          size: 24, color: Appcolor.yellowText(context)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(children: [
              Expanded(
                child: QRView(
                  cameraFacing:
                      cameraFacing ? CameraFacing.back : CameraFacing.front,
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: const Color(0xFFFDB623),
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300 * _zoomValue,
                  ),
                ),
              ),
              if (!isCameraOn)
                Expanded(
                  child: SizedBox.expand(
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: CustomButton(
                            text: 'Scan another QR',
                            backgroundColor: Appcolor.yellowText(context),
                            textColor: Colors.black,
                            height: 52,
                            onPressed: () {
                              setState(() {
                                isCameraOn = true;
                                controller!.resumeCamera();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove,
                            color: Appcolor.yellowText(context)),
                        onPressed: () {
                          setState(() {
                            _zoomValue = (_zoomValue - 0.1).clamp(0.5, 2.0);
                          });
                        },
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Appcolor.yellowText(context),
                          value: _zoomValue,
                          min: 0.5,
                          max: 2.0,
                          onChanged: (value) {
                            setState(() {
                              _zoomValue = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add,
                            color: Appcolor.yellowText(context)),
                        onPressed: () {
                          setState(() {
                            _zoomValue = (_zoomValue + 0.1).clamp(0.5, 2.0);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
