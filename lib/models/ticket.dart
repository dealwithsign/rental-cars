import 'package:equatable/equatable.dart';

class TicketModels extends Equatable {
  final id;
  final paymentLinks;
  final userId;
  final bookingId;
  final String userName;
  final DateTime createdAt;

  TicketModels({
    required this.id,
    required this.paymentLinks,
    required this.userId,
    required this.bookingId,
    required this.userName,
    required this.createdAt,
  });

  factory TicketModels.fromJson(Map<String, dynamic> json) {
    return TicketModels(
      id: json['id'].toString(),
      paymentLinks: json['payment_links'],
      userId: json['user_id'].toString(),
      bookingId: json['booking_id'].toString(),
      userName: json['user_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_links': paymentLinks,
      'user_id': userId,
      'booking_id': bookingId,
      'user_name': userName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  List<Object> get props => [
        id,
        paymentLinks,
        userId,
        bookingId,
        userName,
        createdAt,
      ];
}
