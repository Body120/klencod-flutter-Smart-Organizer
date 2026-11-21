import 'package:flutter/material.dart';

import 'models/installed_app.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartOrganizerApp());
}

class SmartOrganizerApp extends StatelessWidget {
  const SmartOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Organizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8274FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF10131C),
      ),
      home: const DashboardScreen(),
    );
  }
}