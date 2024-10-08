import 'package:flutter/material.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/views/generate_qr_page%20.dart';

class QrTypeTile extends StatelessWidget {
  final String text;
  final String imagePath;
  const QrTypeTile({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Appcolor.cardColor(context),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(imagePath),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenerateQrCodePage(icon: imagePath),
            ),
          );
        },
      ),
    );
  }
}
