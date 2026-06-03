import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HomestayApp());
}

class HomestayApp extends StatelessWidget {
  const HomestayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homestay2U Malaysia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 78, 99, 103)),
        useMaterial3: true,
      ),
      //home: const (),
    );
  }
}