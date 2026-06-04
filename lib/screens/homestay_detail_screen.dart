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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(homestay.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('RM ${homestay.price.toStringAsFixed(2)} / night', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text('${homestay.district}, ${homestay.state}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(homestay.description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
                  
                  if (homestay.activities.isNotEmpty) ...[
                    const Divider(height: 30),
                    const Text('Activities Available', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: homestay.activities.map((act) => Chip(label: Text(act), backgroundColor: Colors.teal[50])).toList(),
                    ),
                  ],

                  if (homestay.amenities.isNotEmpty) ...[
                    const Divider(height: 30),
                    const Text('Amenities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: homestay.amenities.map((ame) => Chip(label: Text(ame), backgroundColor: Colors.blueGrey[50])).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[300],
      child: const Icon(Icons.home_work_outlined, size: 80, color: Colors.grey),
    );
  }
}