import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Property {
  final String id;
  final String title;
  final double price;
  final LatLng location;
  final String image;

  Property({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.image,
  });
}

// Generate Random Properties
List<Property> generateRandomProperties() {
  final random = Random();

  // Qatar boundaries (approximately)
  final qatarCenter = LatLng(25.2854, 51.5310);
  final properties = <Property>[];

  // Property types for random generation
  final propertyTypes = [
    'Luxury Villa',
    'Modern Apartment',
    'Penthouse',
    'Studio Apartment',
    'Townhouse',
    'Beach Villa',
    'Family Home',
  ];

  // Generate 15 random properties
  for (int i = 0; i < 15; i++) {
    // Random location within Qatar (roughly within 30km radius)
    final lat = qatarCenter.latitude +
        (random.nextDouble() - 0.5) * 0.5; // ±0.25 degrees
    final lng = qatarCenter.longitude +
        (random.nextDouble() - 0.5) * 0.5; // ±0.25 degrees

    // Random price between 500,000 and 5,000,000
    final price = 0; //500000 + random.nextInt(4500000);

    // Random property type
    final propertyType = propertyTypes[random.nextInt(propertyTypes.length)];

    properties.add(
      Property(
        id: 'prop_${i + 1}',
        title: propertyType,
        price: price.toDouble(),
        location: LatLng(lat, lng),
        image:
            'assets/images/placeholder.jpg', // Replace with your placeholder image
      ),
    );
  }

  return properties;
}
