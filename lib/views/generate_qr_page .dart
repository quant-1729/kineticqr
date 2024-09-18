import 'package:flutter/material.dart';
import 'package:kineticqr/widgets/custom_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

class GenerateQrCodePage extends StatefulWidget {
  final String icon;
  const GenerateQrCodePage({Key? key, required this.icon}) : super(key: key);

  @override
  _GenerateQrCodePageState createState() => _GenerateQrCodePageState();
}

class _GenerateQrCodePageState extends State<GenerateQrCodePage> {
  String _inputText = '';
  String _qrData = '';

  void _updateQrCode(String data) {
    setState(() {
      _qrData = data;
    });
  }

  Future<void> _shareQrCode() async {
    try {
      // Create a picture recorder to capture the QR code image
      final qrValidationResult = QrValidator.validate(
        data: _qrData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrPainter = QrPainter.withQr(
          qr: qrValidationResult.qrCode!,
          color: const Color(0xFF000000),
          emptyColor: const Color(0xFFFFFFFF),
          gapless: true,
        );

        // Define the size of the QR code image
        final picData = await qrPainter.toImageData(200); // You can adjust the size here

        // Save the QR code image to a temporary directory
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/qr_code.png';
        final file = File(path);

        // Write the image data to the file
        await file.writeAsBytes(picData!.buffer.asUint8List());

        // Share the file using the share_plus package
        await Share.shareFiles([path], text: 'Here is my QR code!');
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR code: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Generate QR Code'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFFDB623),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration:  BoxDecoration(
          color: Color(0xFF353535).withOpacity(.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF424242),
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  top: BorderSide(color: Color(0xFFFDB623), width: 3),
                  bottom: BorderSide(color: Color(0xFFFDB623), width: 3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // QR Code
                  if (_qrData.isNotEmpty)
                    Container(
                      color: Colors.white,
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                        gapless: true,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // TextField for user input
                  TextField(
                    onChanged: (text) {
                      _inputText = text;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter data',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFDB623)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  // Button to generate QR code
                  CustomButton(text: "Generate QR Code", backgroundColor: Color(0xFFFDB623), textColor: Colors.black, onPressed: (){
                    _updateQrCode(_inputText);

                  }),
                  const SizedBox(height: 16),
                  if (_qrData.isNotEmpty)
                    CustomButton(text: "Share QR Code", backgroundColor: Color(0xFFFDB623), textColor: Colors.black, onPressed: (){
                      _shareQrCode();
                    }),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}