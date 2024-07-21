// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class BookingModels extends Equatable {
  String id;
  final String carId;
  final String carName;
  final DateTime selectedDate;
  final String selectedTime;
  final int selectedPassengers;
  final String selectedLocationPick;
  final String selectedLocationDrop;
  final String carFrom;
  final String carTo;
  final DateTime carDate;
  final String userId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final bool isPayment;
  final int totalPayment;

  BookingModels({
    required this.id,
    required this.carId,
    required this.carName,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedPassengers,
    required this.selectedLocationPick,
    required this.selectedLocationDrop,
    required this.carFrom,
    required this.carTo,
    required this.carDate,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.isPayment,
    required this.totalPayment,
  });

  factory BookingModels.fromJson(Map<String, dynamic> json) {
    return BookingModels(
      id: json['id'].toString(),
      carId: json['car_id'].toString(),
      carName: json['car_name'],
      selectedDate: DateTime.parse(json['selected_date']),
      selectedTime: json['selected_time'],
      selectedPassengers: json['selected_passengers'],
      selectedLocationPick: json['selected_location_pick'],
      selectedLocationDrop: json['selected_location_drop'],
      carFrom: json['car_from'],
      carTo: json['car_to'],
      carDate: DateTime.parse(json['car_date']),
      userId: json['user_id'].toString(),
      userName: json['user_name'],
      userPhone: json['user_phone'],
      userEmail: json['user_email'],
      isPayment: json['isPayment'],
      totalPayment: json['total_payment'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'car_id': carId,
      'car_name': carName,
      'selected_date': selectedDate.toIso8601String(),
      'selected_time': selectedTime,
      'selected_passengers': selectedPassengers,
      'selected_location_pick': selectedLocationPick,
      'selected_location_drop': selectedLocationDrop,
      'car_from': carFrom,
      'car_to': carTo,
      'car_date': carDate.toIso8601String(),
      'user_id': userId,
      'user_name': userName,
      'user_phone': userPhone,
      'user_email': userEmail,
      'isPayment': isPayment,
      'total_payment': totalPayment,
    };
  }

  @override
  List<Object?> get props => [
        id,
        carId,
        carName,
        selectedDate,
        selectedTime,
        selectedPassengers,
        selectedLocationPick,
        selectedLocationDrop,
        carFrom,
        carTo,
        carDate,
        userId,
        userName,
        userPhone,
        userEmail,
        isPayment,
        totalPayment,
      ];
}
