import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:kineticqr/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/Bottomnavbar.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF333333),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
            ),
            Image.asset(
              'Assets/qr_icon_1.png',
              height: 200.h,
              width: 200.w,
            ),
            SizedBox(
              height: 200.h,
            ),
            const Center(
              child: Text(
                "Scan Or Create Any QR \n Let's Get Started",
                style: TextStyle(fontSize: 17, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 56.w),
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Appcolor.yellowText(context),
                    )
                  : CustomButton(
                      text: "Let's Start",
                      backgroundColor: Appcolor.yellow,
                      textColor: Colors.white,
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('newUser', false).then(
                          (_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomAppBarPage(),
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
