import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kineticqr/views/Settings.dart';
import 'package:kineticqr/views/qr_generater_grid.dart';
import 'package:kineticqr/views/qr_screen.dart';

import 'navbar.dart';


class BottomAppBarPage extends StatefulWidget {
  final int current_page_index;
  BottomAppBarPage({this.current_page_index = 0});
  @override
  _BottomAppBarPageState createState() => _BottomAppBarPageState();
}

class _BottomAppBarPageState extends State<BottomAppBarPage> {
  int _pageIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  late List<Widget> _pages;

  void _goToMyLearnings() {
    setState(() {
      _pageIndex = 2;
      _pageController.animateToPage(
        2,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _onItemTapped(int index, context) async {
    print("Navigating to index: $index");
    setState(() {
      _pageIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }



  @override
  void initState() {
    super.initState();

    _pageIndex = widget.current_page_index; // Set initial index
    _pageController = PageController(initialPage: widget.current_page_index);

    _pages = [
      QrGeneraterGrid(), // Index 0
      QRScreen(),        // Index 1
      SettingsPage()         // Index 2
    ];

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          children: _pages,
        ),
        bottomNavigationBar: BottomNavBar(
          onTap: (int index) {
            _onItemTapped(index, context);
          },
          pageIndex: _pageIndex,
        ),
      ),
    );
  }
}
