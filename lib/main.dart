import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kineticqr/provider/theme_provider.dart';
import 'package:kineticqr/views/onboarding.dart';
import 'package:kineticqr/widgets/Bottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isNewUser = prefs.getBool('newUser') ?? true;
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(
        isNewUser: isNewUser,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isNewUser;

  const MyApp({Key? key, required this.isNewUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'KineticQR',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          home: child,
        );
      },
      child: isNewUser ? const Onboarding() : const BottomAppBarPage(),
    );
  }
}
