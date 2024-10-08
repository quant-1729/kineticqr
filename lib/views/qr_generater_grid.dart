import 'package:flutter/material.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/widgets/qr_types_tile.dart';

class QrGeneraterGrid extends StatefulWidget {
  const QrGeneraterGrid({super.key});

  @override
  State<QrGeneraterGrid> createState() => _QrGeneraterGridState();
}

class _QrGeneraterGridState extends State<QrGeneraterGrid> {
  List<String> routes = [
    'Assets/contact.png',
    'Assets/gmail.png',
    'Assets/instagram.png',
    'Assets/website.png',
    'Assets/whatsapp.png',
    'Assets/wifi.png',
    'Assets/text.png'
  ];
  List<String> names = [
    'Contact',
    'Gmail',
    'Instagram',
    'Website',
    'WhatsApp',
    'Wi-fi',
    'Text Data'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolor.yellow,
        centerTitle: true,
        title: const Text(
          'Generate your own QR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: Appcolor.backgroundColor(context),
        ),
        child: Column(
          children: [
            ...[0, 1, 2, 3, 4, 5, 6].map((i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: QrTypeTile(text: names[i], imagePath: routes[i]),
              );
            }),
          ],
        ),
      ),
    );
  }
}
