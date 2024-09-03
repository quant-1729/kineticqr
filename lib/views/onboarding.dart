import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/views/qr_screen.dart';
import 'package:kineticqr/widgets/custom_button.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF333333),

        ),
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
            ),
            Image.asset('Assets/qr_icon_1.png', height: 200.h,width: 200.w,),
            SizedBox(height: 200.h,),
            const Center(
              child: Text(
                "Scan Or Create Any QR \n Let's Get Started",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 56.w),
              child: CustomButton(text: "Let's Start", backgroundColor: Appcolor.yellow, textColor: Colors.white, onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> QRScreen()
                ));
              }),

            )

          ],
        ),
      ),
    );
  }
}
