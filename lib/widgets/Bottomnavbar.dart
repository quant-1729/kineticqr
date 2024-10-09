import 'package:flutter/material.dart';
import 'package:kineticqr/views/Settings.dart';
import 'package:kineticqr/views/qr_generater_grid.dart';
import 'package:kineticqr/views/qr_screen.dart';

import 'navbar.dart';

class BottomAppBarPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int current_page_index;
  const BottomAppBarPage({super.key, this.current_page_index = 0});
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _onItemTapped(int index, context) async {
    print("Navigating to index: $index");
    setState(() {
      _pageIndex = index;
      _pageController.jumpToPage(
        index,
        // duration: Duration(milliseconds: 300),
        // curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.current_page_index; // Set initial index
    _pageController = PageController(initialPage: widget.current_page_index);

    _pages = [
      const QrGeneraterGrid(), // Index 0
      const QRScreen(), // Index 1
      const SettingsPage() // Index 2
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
