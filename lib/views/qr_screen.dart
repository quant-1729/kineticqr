import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class QRScreen extends StatefulWidget {
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  double _zoomValue = 1.0;
  bool cameraFacing = true; // Initial camera facing direction
  bool flashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF6d6c6b),
          image: DecorationImage(
            image: AssetImage('Assets/home_background.jpg'),
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
                        onPressed: () => _pickImageFromGallery(),
                        icon: Icon(Icons.perm_media, size: 24, color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => _toggleFlash(),
                        icon: Icon(
                          flashOn ? Icons.flash_on : Icons.flash_off,
                          size: 24,
                          color: flashOn ? Colors.yellow : Colors.white,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => _flipCamera(),
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
                  Padding(
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
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });

      if (_isURL(qrText!)) {
        _launchURL(qrText!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned Code: $qrText')),
        );
      }
    });
  }

  void _toggleFlash() async {
    if (controller != null) {
      final isFlashOn = await controller!.getFlashStatus();
      await controller!.toggleFlash();
      setState(() {
        flashOn = !isFlashOn!;
      });
    }
  }

  void _flipCamera() async {
    if (controller != null) {
      await controller!.flipCamera();
      setState(() {
        cameraFacing = !cameraFacing;
      });
    }
  }

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = pickedFile.path;
      // Implement your QR code scanning logic for the image file here
      // You may need a separate package or method to scan QR codes from images
    }
  }

  bool _isURL(String text) {
    return Uri.tryParse(text)?.hasAbsolutePath ?? false;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
