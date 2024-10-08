import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_button.dart';

class QRScanDialog extends StatelessWidget {
  final String qrImagePath;
  final String qrText;
  final QRViewController controller;

  const QRScanDialog(
      {required this.qrImagePath,
      required this.qrText,
      required this.controller});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode
          .externalApplication, // Launches the URL in an external browser
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black
          .withOpacity(0.8), // Use the same theme as the QR scanning page
      title: const Text(
        'Scanned QR Code',
        style: TextStyle(color: Colors.white),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // QR Image
          Image.asset(
            'Assets/icons8-qr-100 (4).png',
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          // URL Text
          Text(
            qrText,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 7,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Copy to clipboard',
            backgroundColor: Appcolor.yellowText(context),
            textColor: Colors.black,
            onPressed: () {
              _copyToClipboard(qrText, context);
            },
          ),
          const SizedBox(height: 16),
          // Open URL Button
          CustomButton(
            text: "Open in Browser",
            backgroundColor: Appcolor.yellowText(context),
            textColor: Colors.black,
            onPressed: () {
              // Ensure that the URL is valid
              if (_isValidUrl(qrText)) {
                _launchURL(qrText);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                    'Invalid URL: $qrText',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )),
                );
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  bool _isValidUrl(String url) {
    // Check if URL is valid and contains "http" or "https"
    return Uri.tryParse(url)?.hasAbsolutePath ??
        false && (url.startsWith('http') || url.startsWith('https'));
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }
}
