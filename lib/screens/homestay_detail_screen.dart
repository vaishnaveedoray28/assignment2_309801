import 'package:flutter/material.dart';
import '../models/homestay.dart';

class HomestayDetailScreen extends StatelessWidget {
  final HomestayModel homestay;

  const HomestayDetailScreen({super.key, required this.homestay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(homestay.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 147, 166),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}