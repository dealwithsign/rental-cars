// data/models/ticket_model.dart
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';

class VirtualAccountNumber extends Equatable {
  final String bank;
  final String vaNumber;

  const VirtualAccountNumber({
    required this.bank,
    required this.vaNumber,
  });

  factory VirtualAccountNumber.fromJson(Map<String, dynamic> json) {
    return VirtualAccountNumber(
      bank: json['bank'] ?? '',
      vaNumber: json['va_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'va_number': vaNumber,
    };
  }

  @override
  List<Object?> get props => [bank, vaNumber];
}

class TicketModels extends Equatable {
  final String id;
  final String? paymentLinks;
  final String userId;
  final String bookingId;
  final String userName;
  final DateTime createdAt;
  final DateTime carDate;
  final String carFrom;
  final String carTo;
  final String carName;
  final String selectedTime;
  final int selectedPassengers;
  final bool isPaid;
  final String ownerCar;
  final String selected_location_drop;
  final String selected_location_pick;
  final String statusCode;
  final String transactionId;
  final String grossAmount;
  final String currency;
  final String orderId;
  final String paymentType;
  final String transaction_status;
  final DateTime settlement_time;
  final DateTime expiry_time;
  final List<VirtualAccountNumber> vaNumbers; // Add this property

  const TicketModels({
    required this.id,
    required this.paymentLinks,
    required this.userId,
    required this.bookingId,
    required this.userName,
    required this.createdAt,
    required this.carDate,
    required this.carFrom,
    required this.carTo,
    required this.carName,
    required this.selectedTime,
    required this.selectedPassengers,
    this.isPaid = false,
    required this.ownerCar,
    required this.selected_location_drop,
    required this.selected_location_pick,
    required this.statusCode,
    required this.transactionId,
    required this.grossAmount,
    required this.currency,
    required this.orderId,
    required this.paymentType,
    required this.transaction_status,
    required this.settlement_time,
    required this.expiry_time,
    required this.vaNumbers, // Add this initialization
  });

  factory TicketModels.fromJson(Map<String, dynamic> json) {
    var vaNumbersJson = json['va_numbers'] as List<dynamic>? ?? [];
    var vaNumbers = vaNumbersJson
        .map((vaJson) => VirtualAccountNumber.fromJson(vaJson))
        .toList();

    return TicketModels(
      id: json['id']?.toString() ?? '',
      paymentLinks: json['payment_links'],
      userId: json['user_id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString() ?? '',
      userName: json['user_name'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      carDate:
          DateTime.parse(json['car_date'] ?? DateTime.now().toIso8601String()),
      carFrom: json['city_from'] ?? '',
      carTo: json['city_to'] ?? '',
      carName: json['car_name'] ?? '',
      selectedTime: json['selected_date'] ?? '',
      selectedPassengers: json['selected_passengers'] ?? 0,
      isPaid: json['is_paid'] ?? false,
      ownerCar: json['owner_car'] ?? '',
      selected_location_drop: json['selected_location_drop'] ?? '',
      selected_location_pick: json['selected_location_pick'] ?? '',
      statusCode: json['status_code'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      grossAmount: json['gross_amount'] ?? '',
      currency: json['currency'] ?? '',
      orderId: json['order_id'] ?? '',
      paymentType: json['payment_type'] ?? '',
      transaction_status: json['transaction_status'] ?? '',
      settlement_time: DateTime.parse(
          json['settlement_time'] ?? DateTime.now().toIso8601String()),
      expiry_time: DateTime.parse(
          json['expiry_time'] ?? DateTime.now().toIso8601String()),
      vaNumbers: vaNumbers, // Add this parsing
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
      'car_date': carDate.toIso8601String(),
      'car_from': carFrom,
      'car_to': carTo,
      'car_name': carName,
      'is_paid': isPaid,
      'selected_date': selectedTime,
      'selected_passengers': selectedPassengers,
      'owner_car': ownerCar,
      'selected_location_drop': selected_location_drop,
      'selected_location_pick': selected_location_pick,
      'status_code': statusCode,
      'transaction_id': transactionId,
      'gross_amount': grossAmount,
      'currency': currency,
      'order_id': orderId,
      'payment_type': paymentType,
      'transaction_status': transaction_status,
      'settlement_time': settlement_time.toIso8601String(),
      'expiry_time': expiry_time.toIso8601String(),
      'va_numbers':
          vaNumbers.map((va) => va.toJson()).toList(), // Add this field
    };
  }

  @override
  List<Object?> get props => [
        id,
        paymentLinks,
        userId,
        bookingId,
        userName,
        createdAt,
        carDate,
        carFrom,
        carTo,
        carName,
        isPaid,
        selectedTime,
        selectedPassengers,
        ownerCar,
        selected_location_drop,
        selected_location_pick,
        statusCode,
        transactionId,
        grossAmount,
        currency,
        orderId,
        paymentType,
        transaction_status,
        settlement_time,
        expiry_time,
        vaNumbers, // Add this property
      ];
}
