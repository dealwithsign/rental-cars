// data/models/users_model.dart
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  late int phone_number;
  final DateTime created_at;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone_number,
    required this.created_at,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      username: json['username'] as String,
      phone_number: int.tryParse(json['phone_number'].toString()) ?? 0,
      created_at: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phone_number': phone_number,
      'created_at': created_at.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    int? phone_number,
    DateTime? created_at,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phone_number: phone_number ?? this.phone_number,
      created_at: created_at ?? this.created_at,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        phone_number,
        created_at,
      ];
}
