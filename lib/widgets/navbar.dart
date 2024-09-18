import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  BottomNavBar({
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      height: 60.h, // Responsive height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          navItem(
            Icons.perm_media,
            pageIndex == 0,
            onTap: () => onTap(0),
          ),
          Center(
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white, Colors.transparent],
                  stops: [0.7, 1.0],
                ),
              ),
              child: InkWell(
                onTap: () => onTap(1),
                child: CircleAvatar(
                  radius: 35.r,
                  backgroundColor: Color(0xFFFDB623),
                  child: Image.asset(
                    'Assets/qr_icon_1.png',
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
              ),
            ),
          ),
          navItem(
            Icons.play_circle_fill_rounded,
            pageIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: selected
                  ? BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              )
                  : null,
              child: Icon(
                icon,
                color: selected ? Color(0xFFFDB623) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
