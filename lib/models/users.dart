class UserModel {
  final String id;
  final String email;
  final String username;
  late int phone_number;
  final DateTime created_at;
  final String url_profile;
  final DateTime last_sign_in;
  final String provider;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone_number,
    required this.created_at,
    required this.last_sign_in,
    this.url_profile = '',
    required this.provider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      username: json['username'] as String,
      phone_number: int.tryParse(json['phoneNumber'].toString()) ?? 0,
      created_at: DateTime.parse(json['created_at'] as String),
      url_profile: json['url_profile'] as String ?? '',
      last_sign_in: DateTime.parse(json['last_sign_in'] as String),
      provider: json['provider'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phone_number': phone_number,
      'created_at': created_at.toIso8601String(),
      'url_profile': url_profile,
      'last_sign_in': last_sign_in.toIso8601String(),
      'provider': provider,
    };
  }

  // Add a copyWith method
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    int? phone_number,
    DateTime? created_at,
    String? url_profile,
    DateTime? last_sign_in,
    String? provider,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phone_number: phone_number ?? this.phone_number,
      created_at: created_at ?? this.created_at,
      url_profile: url_profile ?? this.url_profile,
      last_sign_in: last_sign_in ?? this.last_sign_in,
      provider: provider ?? this.provider,
    );
  }
}
