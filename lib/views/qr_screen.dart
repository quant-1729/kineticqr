import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScreen extends StatefulWidget {
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  double _zoomValue = 1.0;
  bool camera_facing= true; // Initial zoom value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'Assets/home_background.jpg', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5), // Adjusted opacity
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.perm_media, size: 24)),
                        Spacer(),
                        IconButton(onPressed: () {}, icon: Icon(Icons.flash_on, size: 24)),
                        Spacer(),
                        IconButton(onPressed: () {
                          setState(() {
                            camera_facing= !camera_facing;
                          });
                        }, icon: Icon(Icons.cameraswitch_rounded, size: 24)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              // QRbox
              Expanded(
                child: QRView(
                  cameraFacing: camera_facing ? CameraFacing.back : CameraFacing.front,
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Color(0xFFFDB623), // Your border color
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300 * _zoomValue, // Apply zoom effect
                  ),

                )

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Column(
                  children: [

                    Container(

                      child: Padding(
                        padding: const EdgeInsets.symmetric( vertical: 10),
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), // Adjusted opacity
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                IconButton(onPressed: () {}, icon: Icon(Icons.perm_media, size: 24)),
                                Spacer(),
                                IconButton(onPressed: () {}, icon: Icon(Icons.flash_on, size: 24)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          child: Center(
                            child: Container(
                              width: 80, // Slightly larger to include gradient
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [Colors.white, Colors.transparent],
                                  stops: [0.7, 1.0],
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(0xFFFDB623),
                                child: Image.asset(
                                  'Assets/qr_icon_1.png', // Adjust the icon size
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )


                  ],
                ),
              ),
              SizedBox(height: 20),

              // Add the circular avatar at the bottom slider

              SizedBox(height: 20),
            ],
          ),
        ],
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
