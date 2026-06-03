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
            homestay.imageUrl.isNotEmpty
                ? Image.network(
                    homestay.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 250,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(color: Colors.teal)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          
          ],
        ),
      ),
    );
  }
}

Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[300],
      child: const Icon(Icons.home_work_outlined, size: 80, color: Colors.grey),
    );
}
