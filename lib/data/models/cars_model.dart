// data/models/cars_model.dart
import 'package:equatable/equatable.dart';

class CarsModels extends Equatable {
  final String id;
  final String carLogo;
  final String carName;
  final String carClass;
  final String carTimeDateFrom;
  final String carFrom;
  final String carTo;
  final int availableSeats;
  final String carDesc;
  final String carPrice;
  final DateTime carDate;
  final int seats;
  final String ownerCar;
  final double latitude; // added latitude
  final double longitude; // added longitude
  final bool include_driver;
  final String facility1;
  final String facility2;
  final String facility3;
  final String facility4;
  final String facility5;
  final bool includeKey;
  final bool isPayment;
  final int remainingSeats;
  final int selectedSeats; // added selectedSeats

  const CarsModels({
    required this.id,
    this.carLogo = "",
    this.carName = "",
    this.carClass = "",
    this.carTimeDateFrom = "",
    this.carFrom = "",
    this.carTo = "",
    this.availableSeats = 0,
    this.carDesc = "",
    this.carPrice = "",
    required this.carDate,
    this.ownerCar = "",
    this.seats = 0,
    required this.latitude, // make latitude required
    required this.longitude, // make longitude required
    this.include_driver = false,
    this.facility1 = "",
    this.facility2 = "",
    this.facility3 = "",
    this.facility4 = "",
    this.facility5 = "",
    this.includeKey = false,
    this.isPayment = false,
    required this.remainingSeats,
    this.selectedSeats = 0, // default value for selectedSeats
  });

  factory CarsModels.fromJson(Map<String, dynamic> json) {
    return CarsModels(
      id: json['id'] ?? '', // Provide a default value if null
      carLogo: json['car_logo'] ?? '', // Provide a default value if null
      carName: json['car_name'] ?? '', // Provide a default value if null
      carClass: json['car_class'] ?? '', // Provide a default value if null
      carTimeDateFrom:
          json['car_time_date_from'] ?? '', // Provide a default value if null
      carFrom: json['car_from'] ?? '', // Provide a default value if null
      carTo: json['car_to'] ?? '', // Provide a default value if null
      availableSeats:
          json['available_seats'] ?? 0, // Provide a default value if null
      carDesc: json['car_desc'] ?? '', // Provide a default value if null
      carPrice: json['car_price'] ?? '', // Provide a default value if null
      carDate: DateTime.parse(json['car_date'] ??
          DateTime.now().toIso8601String()), // Provide a default value if null
      seats: json['seats'] ?? 0, // Provide a default value if null
      ownerCar: json['owner_car'] ?? '', // Provide a default value if null
      latitude: (json['latitude'] ?? 0.0)
          .toDouble(), // Provide a default value if null
      longitude: (json['longitude'] ?? 0.0)
          .toDouble(), // Provide a default value if null
      include_driver:
          json['include_driver'] ?? false, // Provide a default value if null
      facility1: json['facility1'] ?? '', // Provide a default value if null
      facility2: json['facility2'] ?? '', // Provide a default value if null
      facility3: json['facility3'] ?? '', // Provide a default value if null
      facility4: json['facility4'] ?? '', // Provide a default value if null
      facility5: json['facility5'] ?? '', // Provide a default value if null
      includeKey:
          json['includeKey'] ?? false, // Provide a default value if null
      isPayment: json['isPayment'] ?? false, // Provide a default value if null
      remainingSeats:
          json['remaining_seats'] ?? 0, // Provide a default value if null
      selectedSeats:
          json['selected_seats'] ?? 0, // Provide a default value if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "car_logo": carLogo,
      "car_name": carName,
      "car_class": carClass,
      "car_time_date_from": carTimeDateFrom,
      "car_from": carFrom,
      "car_to": carTo,
      "available_seats": availableSeats,
      "car_desc": carDesc,
      "car_price": carPrice,
      "car_date": carDate.toIso8601String(),
      "seats": seats,
      "owner_car": ownerCar,
      "latitude": latitude, // add latitude to json
      "longitude": longitude, // add longitude to json
      "include_driver": include_driver,
      "facility1": facility1,
      "facility2": facility2,
      "facility3": facility3,
      "facility4": facility4,
      "facility5": facility5,
      "includeKey": includeKey,
      "isPayment": isPayment,
      "remaining_seats": remainingSeats,
      "selected_seats": selectedSeats, // add selectedSeats to json
    };
  }

  @override
  List<Object?> get props => [
        id,
        carLogo,
        carName,
        carClass,
        carTimeDateFrom,
        carFrom,
        carTo,
        availableSeats,
        carDesc,
        carPrice,
        carDate,
        seats,
        ownerCar,
        latitude, // add latitude to props
        longitude, // add longitude to props
        include_driver,
        facility1,
        facility2,
        facility3,
        facility4,
        facility5,
        includeKey,
        isPayment,
        remainingSeats,
        selectedSeats, // add selectedSeats to props
      ];
}
