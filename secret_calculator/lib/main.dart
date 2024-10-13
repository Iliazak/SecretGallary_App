import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:secret_calculator/models/gallery_model.dart';
import 'models/contact_model.dart';
import 'pages/password_pages/homepage.dart';
import 'pages/start_pages/startpage.dart';
import 'ui/colors.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GalleryAdapter());
  Hive.registerAdapter(ContactAdapter());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: mainColorDark,
      systemNavigationBarColor: mainColorDark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      themeMode: AppTheme.themeMode,
      theme: AppTheme.themeData,
      home: FutureBuilder<Box<String>>(
        future: Hive.openBox('appPassword'),
        builder: (context, boxSnapshot) {
          if (boxSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (boxSnapshot.hasData && boxSnapshot.data != null) {
            return ValueListenableBuilder<Box<String>>(
              valueListenable: boxSnapshot.data!.listenable(),
              builder: (context, box, _) {
                final String password = box.get('password') ?? '';
                if (password.isNotEmpty) {
                  return HomePage(appPassword: password);
                } else {
                  return const StartPage();
                }
              },
            );
          } else {
            return const StartPage();
          }
        },
      ),
    );
  }
}
