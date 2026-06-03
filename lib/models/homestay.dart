class HomestayModel {
  final String name;
  final double price;
  final String district;
  final String state;
  final String imageUrl;
  final String description;
  final List<String> activities;
  final List<String> amenities;

  const HomestayModel({
    required this.name,
    required this.price,
    required this.district,
    required this.state,
    required this.imageUrl,
    required this.description,
    required this.activities,
    required this.amenities,
  });

  factory HomestayModel.fromJson(Map<String, dynamic> json) {
    return HomestayModel(
      name: (json['name'] ?? '').toString(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      district: (json['district'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      activities: json['activities'] != null
          ? List<String>.from(json['activities'].map((item) => item.toString()))
          : [],
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'].map((item) => item.toString()))
          : [],
    );
  }
}