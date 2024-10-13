import 'package:flutter/material.dart';
import 'package:secret_calculator/pages/password_pages/password_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Change Password"),
            leading: const Icon(Icons.lock_open_outlined),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PasswordPage(
                  isPasswordChanging: true,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text("Join our Telegram Channel"),
            leading: const Icon(Icons.telegram),
            onTap: () => _launchTelegramChannel(),
          ),

          // ListTile(
          //   title: const Text(""),
          //   onTap: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const CreatePasswordPage(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _launchTelegramChannel() async {
    const url = 'https://t.me/zak_workshop';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
