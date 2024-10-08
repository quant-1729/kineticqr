import 'package:flutter/material.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/widgets/custom_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
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
          print('debug rebuilt');
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

  void _showQRScanDialog(String qrText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRScanDialog(
          qrImagePath:
              'Assets/icons8-qr-100.png', // Replace with the correct path to the QR image if needed
          qrText: qrText,
          controller: controller!,
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        // Scan QR from the selected image

        // Show snackbar if no QR code is detected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No QR code found in the image.')),
        );
      } catch (e) {
        // Handle errors in case QR scan fails
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
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF6d6c6b),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.perm_media,
                            size: 24, color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _toggleFlash,
                        icon: Icon(
                          flashOn ? Icons.flash_off : Icons.flash_on,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _toggleCamera,
                        icon: const Icon(Icons.cameraswitch_rounded,
                            size: 24, color: Colors.white),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: CustomButton(
                      text: 'Scan another QR',
                      backgroundColor: Appcolor.yellowText(context),
                      textColor: Colors.black,
                      onPressed: () {
                        setState(() {
                          isCameraOn = true;
                          controller!.resumeCamera();
                        });
                      },
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
                          icon: const Icon(Icons.remove, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _zoomValue = (_zoomValue - 0.1).clamp(0.5, 2.0);
                            });
                          },
                        ),
                        Expanded(
                          child: Slider(
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
                          icon: const Icon(Icons.add, color: Colors.white),
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
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
