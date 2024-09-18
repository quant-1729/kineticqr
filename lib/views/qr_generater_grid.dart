import 'package:flutter/material.dart';

import 'generate_qr_page .dart';

class QrGeneraterGrid extends StatefulWidget {
  const QrGeneraterGrid({super.key});

  @override
  State<QrGeneraterGrid> createState() => _QrGeneraterGridState();
}

class _QrGeneraterGridState extends State<QrGeneraterGrid> {
  List<String> routes = [
    'Assets/icons8-contact-50.png',
    'Assets/icons8-gmail-50.png',
    'Assets/icons8-instagram-48.png',
    'Assets/icons8-website-50.png',
    'Assets/icons8-whatsapp-50.png',
    'Assets/icons8-wifi-40.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF6d6c6b),
          image: const DecorationImage(
            image: AssetImage('Assets/home_background.jpg'),
            fit: BoxFit.fill,
            opacity: 0.2,
          ),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,  // Number of columns in the grid
          ),
          itemCount: routes.length,  // Specify the number of items in the grid
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> GenerateQrCodePage(icon: routes[index])));
              },
              child: Container(
                margin: const EdgeInsets.all(8.0), // Optional: add some spacing
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.yellow,  // Yellow border
                    width: 4,  // Border width
                  ),
                  borderRadius: BorderRadius.circular(6),  // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0), // Padding inside the container
                  child: Center(
                    child: Image.asset(routes[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
