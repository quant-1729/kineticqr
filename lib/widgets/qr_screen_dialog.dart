import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_button.dart';

class QRScanDialog extends StatelessWidget {
  final String qrImagePath;
  final String qrText;

  QRScanDialog({required this.qrImagePath, required this.qrText});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Launches the URL in an external browser
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.8), // Use the same theme as the QR scanning page
      title: Text(
        'Scanned QR Code',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // QR Image
          Image.asset('Assets/icons8-qr-100 (4).png'),
          SizedBox(height: 16),
          // URL Text
          Text(
            qrText,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          // Open URL Button
          CustomButton(
            text: "Open in Browser",
            backgroundColor: Color(0xFFFDB623),
            textColor: Colors.black,
            onPressed: () {
              // Ensure that the URL is valid
              if (_isValidUrl(qrText)) {
                _launchURL(qrText);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid URL: $qrText')),
                );
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  bool _isValidUrl(String url) {
    // Check if URL is valid and contains "http" or "https"
    return Uri.tryParse(url)?.hasAbsolutePath ?? false && (url.startsWith('http') || url.startsWith('https'));
  }
}
