// data/models/touristdestination_model.dart
import 'package:equatable/equatable.dart';

class TouristdestinationModel extends Equatable {
  final String id;
  final String name;
  final String location;
  final String description;
  final String category;
  final String imageUrl;
  final String operatingHours;
  final String ticketPrice;
  final String rating;
  final String? email;
  final String? phoneNumber;

  const TouristdestinationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.operatingHours,
    required this.ticketPrice,
    required this.rating,
    this.email,
    this.phoneNumber,
  });

  factory TouristdestinationModel.fromJson(Map<String, dynamic> json) {
    return TouristdestinationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      operatingHours: json['operating_hours'] ?? '',
      ticketPrice: json['ticket_price'] ?? '',
      rating: json['rating'] ?? '',
      email: json['email'] ?? 'Belum ada email terdaftar',
      phoneNumber: json['phone_number'] ?? 'Belum ada nomor telepon terdaftar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'operating_hours': operatingHours,
      'ticket_price': ticketPrice,
      'rating': rating,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        description,
        category,
        imageUrl,
        operatingHours,
        ticketPrice,
        rating,
        email,
        phoneNumber,
      ];
}
