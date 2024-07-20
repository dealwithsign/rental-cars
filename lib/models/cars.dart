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
  });

  factory CarsModels.fromJson(Map<String, dynamic> json) {
    return CarsModels(
      id: json['id'],
      carLogo: json['car_logo'],
      carName: json['car_name'],
      carClass: json['car_class'],
      carTimeDateFrom: json['car_time_date_from'],
      carFrom: json['car_from'],
      carTo: json['car_to'],
      availableSeats: json['available_seats'],
      carDesc: json['car_desc'],
      carPrice: json['car_price'],
      carDate: DateTime.parse(json['car_date']),
      seats: json['seats'] ?? 0,
      ownerCar: json['owner_car'],
      latitude: json['latitude'].toDouble(), // parse latitude from json
      longitude: json['longitude'].toDouble(), // parse longitude from json
      include_driver: json['include_driver'] ?? false,
      facility1: json['facility1'] ?? "",
      facility2: json['facility2'] ?? "",
      facility3: json['facility3'] ?? "",
      facility4: json['facility4'] ?? "",
      facility5: json['facility5'] ?? "",
      includeKey: json['includeKey'] ?? false,
      isPayment: json['isPayment'] ?? false,
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
      ];
}
