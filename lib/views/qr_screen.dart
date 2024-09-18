import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';


import '../widgets/qr_screen_dialog.dart';

class QRScreen extends StatefulWidget {
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });

      // Show the QR scan dialog with the scanned text
      _showQRScanDialog(qrText!);
    });
  }

  void _showQRScanDialog(String qrText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRScanDialog(
          qrImagePath: 'assets/icons8-qr-100.png', // Replace with the correct path to the QR image if needed
          qrText: qrText,
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
            SnackBar(content: Text('No QR code found in the image.')),
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
        decoration: BoxDecoration(
          color: Color(0xFF6d6c6b),
          image: DecorationImage(
            image: AssetImage('assets/home_background.jpg'),
            fit: BoxFit.fill,
            opacity: 0.2,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _pickImageFromGallery,
                        icon: Icon(Icons.perm_media, size: 24, color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: _toggleFlash,
                        icon: Icon(
                          flashOn ? Icons.flash_off : Icons.flash_on,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: _toggleCamera,
                        icon: Icon(Icons.cameraswitch_rounded, size: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: QRView(
                cameraFacing: cameraFacing ? CameraFacing.back : CameraFacing.front,
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Color(0xFFFDB623),
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300 * _zoomValue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.white),
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
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _zoomValue = (_zoomValue + 0.1).clamp(0.5, 2.0);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
