// data/models/invoices_model.dart
import 'package:equatable/equatable.dart';

class InvoicesModel extends Equatable {
  final String id;
  final String? userId;
  final String? userEmail;
  final String? userName;
  final String? statusCode;
  final String? transactionId;
  final double? grossAmount;
  final String? currency;
  final String? orderId;
  final String? paymentType;
  final String? signatureKey;
  final String? transactionStatus;
  final String? fraudStatus;
  final String? statusMessage;
  final String? merchantId;
  final Map<String, dynamic>? vaNumbers;
  final DateTime? transactionTime;
  final DateTime? settlementTime;
  final DateTime? expiryTime;
  final DateTime createdAt;

  const InvoicesModel({
    required this.id,
    this.statusCode,
    this.userId,
    this.userEmail,
    this.userName,
    this.transactionId,
    this.grossAmount,
    this.currency,
    this.orderId,
    this.paymentType,
    this.signatureKey,
    this.transactionStatus,
    this.fraudStatus,
    this.statusMessage,
    this.merchantId,
    this.vaNumbers,
    this.transactionTime,
    this.settlementTime,
    this.expiryTime,
    required this.createdAt,
  });

  factory InvoicesModel.fromJson(Map<String, dynamic> json) {
    return InvoicesModel(
      id: json['id'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      userName: json['user_name'],
      statusCode: json['status_code'],
      transactionId: json['transaction_id'],
      grossAmount: json['gross_amount']?.toDouble(),
      currency: json['currency'],
      orderId: json['order_id'],
      paymentType: json['payment_type'],
      signatureKey: json['signature_key'],
      transactionStatus: json['transaction_status'],
      fraudStatus: json['fraud_status'],
      statusMessage: json['status_message'],
      merchantId: json['merchant_id'],
      vaNumbers: json['va_numbers'] != null
          ? Map<String, dynamic>.from(json['va_numbers'])
          : null,
      transactionTime: json['transaction_time'] != null
          ? DateTime.parse(json['transaction_time'])
          : null,
      settlementTime: json['settlement_time'] != null
          ? DateTime.parse(json['settlement_time'])
          : null,
      expiryTime: json['expiry_time'] != null
          ? DateTime.parse(json['expiry_time'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_email': userEmail,
      'user_name': userName,
      'status_code': statusCode,
      'transaction_id': transactionId,
      'gross_amount': grossAmount,
      'currency': currency,
      'order_id': orderId,
      'payment_type': paymentType,
      'signature_key': signatureKey,
      'transaction_status': transactionStatus,
      'fraud_status': fraudStatus,
      'status_message': statusMessage,
      'merchant_id': merchantId,
      'va_numbers': vaNumbers,
      'transaction_time': transactionTime?.toIso8601String(),
      'settlement_time': settlementTime?.toIso8601String(),
      'expiry_time': expiryTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userEmail,
        userName,
        statusCode,
        transactionId,
        grossAmount,
        currency,
        orderId,
        paymentType,
        signatureKey,
        transactionStatus,
        fraudStatus,
        statusMessage,
        merchantId,
        vaNumbers,
        transactionTime,
        settlementTime,
        expiryTime,
        createdAt,
      ];
}
