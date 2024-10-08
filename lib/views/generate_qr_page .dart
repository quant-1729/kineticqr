import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/utils/Constants/styles.dart';
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
  final TextEditingController _inputText = TextEditingController();
  String _qrData = '';
  int qrErrorCorrectLevel = 1;
  List<String> errorCorrectionLevels = ['Medium', 'Low', 'Quartile', 'High'];
  bool isEmbeddedImage = false;
  bool advancedSettingVisible = false;

  void _updateQrCode(String data) {
    setState(() {
      _qrData = data;
    });
  }

  // Function to load an image as ui.Image
  Future<ui.Image> loadUiImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  // previously the qr code was fit to the image, with no white margin.
  Future<void> _shareQrCode() async {
    try {
      // Create a picture recorder to capture the QR code image
      final qrValidationResult = QrValidator.validate(
        data: _qrData,
        version: QrVersions.auto,
        errorCorrectionLevel: qrErrorCorrectLevel,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        ui.Image? embeddedImage;

        // Check if embedded image is required
        if (isEmbeddedImage) {
          embeddedImage =
              await loadUiImage(widget.icon); // Load the image from assets
        }

        final qrPainter = QrPainter.withQr(
          qr: qrValidationResult.qrCode!,
          gapless: true,
          embeddedImage: embeddedImage, // Pass the loaded ui.Image here
        );

        // Define the size of the QR code image with extra space for margin
        const int imageSize = 200; // QR code size
        const int marginSize = 12; // white Margin
        const int totalSize = imageSize +
            marginSize * 2; // Total size including margin of both sides

        // Create an image with the QR code and the margin
        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder,
            Rect.fromLTWH(0, 0, totalSize.toDouble(), totalSize.toDouble()));

        // Paint the background (white) to cover the entire canvas including margin
        final paint = Paint()..color = Colors.white;
        canvas.drawRect(
            Rect.fromLTWH(0, 0, totalSize.toDouble(), totalSize.toDouble()),
            paint);

        // Center the QR code by translating the canvas
        final offset = Offset(marginSize.toDouble(), marginSize.toDouble());
        canvas.translate(offset.dx, offset.dy);

        // Paint the QR code onto the canvas (centered with margin)
        qrPainter.paint(
            canvas, Size(imageSize.toDouble(), imageSize.toDouble()));

        // Convert the canvas to an image
        final img =
            await pictureRecorder.endRecording().toImage(totalSize, totalSize);
        final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
        final picData = byteData!.buffer.asUint8List();

        // Save the QR code image to a temporary directory
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/qr_code.png';
        final file = File(path);

        // Write the image data to the file
        await file.writeAsBytes(picData);

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
      backgroundColor: Appcolor.backgroundColor(context),
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Appcolor.yellow,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 90,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Appcolor.cardColor(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    top: BorderSide(
                        color: Appcolor.yellowText(context), width: 3),
                    bottom: BorderSide(
                        color: Appcolor.yellowText(context), width: 3),
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
                          errorCorrectionLevel: qrErrorCorrectLevel,
                          embeddedImage:
                              isEmbeddedImage ? AssetImage(widget.icon) : null,
                        ),
                      ),
                    const SizedBox(height: 16),
                    // TextField for user input
                    TextField(
                      controller: _inputText,
                      decoration: InputDecoration(
                        hintText: 'Enter data',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Appcolor.yellowText(context)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    AdvancedSettingsMenu(),
                    const SizedBox(height: 16),
                    // Button to generate QR code
                    CustomButton(
                      text: "Generate QR Code",
                      backgroundColor: Appcolor.yellowText(context),
                      textColor: Colors.black,
                      onPressed: () {
                        _updateQrCode(_inputText.text);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_qrData.isNotEmpty)
                      CustomButton(
                        text: "Share QR Code",
                        backgroundColor: Appcolor.yellowText(context),
                        textColor: Colors.black,
                        onPressed: () {
                          _shareQrCode();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget AdvancedSettingsMenu() {
    return ExpansionTile(
      title: Text(
        'Advanced settings',
        style: AppStyles.yellowText(context),
      ),
      trailing: Icon(
        advancedSettingVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: Appcolor.yellowText(context),
      ),
      onExpansionChanged: (value) {
        setState(() {
          advancedSettingVisible = value;
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Error Correction Level',
                style: AppStyles.yellowText(context),
              ),
              PopupMenuButton<int>(
                itemBuilder: (_) {
                  return [
                    const PopupMenuItem(value: 1, child: Text('Low')),
                    const PopupMenuItem(value: 0, child: Text('Medium')),
                    const PopupMenuItem(value: 2, child: Text('Quartile')),
                    const PopupMenuItem(value: 3, child: Text('High')),
                  ];
                },
                child: Container(
                  height: 25,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Appcolor.yellow,
                    borderRadius: BorderRadius.circular(7),
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      errorCorrectionLevels[qrErrorCorrectLevel],
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    qrErrorCorrectLevel = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Add icon in center',
                style: AppStyles.yellowText(context),
              ),
              Switch(
                value: isEmbeddedImage,
                activeColor: Appcolor.yellowText(context),
                onChanged: (value) {
                  setState(() {
                    isEmbeddedImage = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
