import 'package:flutter/material.dart';
import 'package:kineticqr/provider/theme_provider.dart';
import 'package:kineticqr/utils/Constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVibrateOn = true;
  bool isScannerDefault = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isVibrateOn = prefs.getBool('vibrate') ?? true;
      isScannerDefault = prefs.getBool('scannerDefault') ?? false;
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrate', isVibrateOn);
    await prefs.setBool('scannerDefault', isScannerDefault);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.backgroundColor(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                color: Appcolor.yellowText(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            buildSettingCard(
              context,
              icon: Icons.vibration,
              title: "Vibrate",
              subtitle: "Vibration when action is done.",
              value: isVibrateOn,
              onChanged: (value) {
                setState(() {
                  isVibrateOn = value;
                });
                _savePreferences();
              },
            ),
            const SizedBox(height: 12),
            buildSettingCard(
              context,
              icon: Icons.dark_mode,
              title: "Dark Mode",
              subtitle: "Set preference for dark theme.",
              value: Provider.of<ThemeProvider>(context).themeMode ==
                  ThemeMode.dark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(value);
              },
            ),
            const SizedBox(
              height: 12,
            ),
            buildSettingCard(
              context,
              icon: Icons.home,
              title: "Scanner as deault page",
              subtitle: "Set QR Scanner as default page.",
              value: isScannerDefault,
              onChanged: (value) {
                setState(() {
                  isScannerDefault = value;
                });
                _savePreferences();
              },
            ),
            const SizedBox(height: 32),
            Text(
              "Support",
              style: TextStyle(
                color: Appcolor.yellowText(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            buildSupportCard(
              context,
              icon: Icons.star_rate,
              title: "Rate Us",
              subtitle: "Your best reward to us.",
              onTap: () {
                // Handle Rate Us action
              },
            ),
            buildSupportCard(
              context,
              icon: Icons.share,
              title: "Share",
              subtitle: "Share app with others.",
              onTap: () {
                // Handle Share action
              },
            ),
            buildSupportCard(
              context,
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              subtitle: "Follow our policies that benefit you.",
              onTap: () {
                // Handle Privacy Policy action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Appcolor.cardColor(context),
      child: ListTile(
        leading: Icon(icon, color: Appcolor.yellowText(context), size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Appcolor.yellowText(context),
          inactiveThumbColor: Colors.grey,
        ),
      ),
    );
  }

  Widget buildSupportCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Appcolor.cardColor(context),
      child: ListTile(
        leading: Icon(icon, color: Appcolor.yellowText(context), size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
