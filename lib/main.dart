import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kineticqr/views/onboarding.dart';
import 'package:kineticqr/widgets/Bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isNewUser = prefs.getBool('newUser') ?? true;
  final bool isDarkMode = prefs.getBool('darkMode') ?? false;
  runApp(MyApp(isDarkMode: isDarkMode, isNewUser: isNewUser,));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final bool isNewUser;

  const MyApp({Key? key, required this.isDarkMode, required this.isNewUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'KineticQR',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: child,
        );
      },
      child: isNewUser ? const Onboarding() : BottomAppBarPage(),
    );
  }
}
