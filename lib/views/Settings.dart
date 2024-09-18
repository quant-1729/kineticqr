import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVibrateOn = true;
  bool isDarkModePreferred = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isVibrateOn = prefs.getBool('vibrate') ?? true;
      isDarkModePreferred = prefs.getBool('darkMode') ?? false;
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrate', isVibrateOn);
    await prefs.setBool('darkMode', isDarkModePreferred);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C4B4A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                color: Color(0xFFFFC107),
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
                  _savePreferences();
                });
              },
            ),
            const SizedBox(height: 12),

            buildSettingCard(
              context,
              icon: Icons.dark_mode,
              title: "Dark Mode",
              subtitle: "Set preference for dark theme.",
              value: isDarkModePreferred,
              onChanged: (value) {
                setState(() {
                  isDarkModePreferred = value;
                  _savePreferences();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        value
                            ? "Dark mode preference set. Restart app to apply."
                            : "Light mode preference set. Restart app to apply."
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            const Text(
              "Support",
              style: TextStyle(
                color: Color(0xFFFFC107),
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
      color: const Color(0xFF383736),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFC107), size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFFC107),
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
      color: const Color(0xFF383736),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFC107), size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        onTap: onTap,
      ),
    );
  }
}