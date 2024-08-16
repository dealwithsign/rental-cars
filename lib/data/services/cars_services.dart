// data/services/cars_services.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cars_model.dart';

class CarsServices {
  final supabase = Supabase.instance.client;

  // services to get all cars
  Future<List<CarsModels>> getAllCars() async {
    List<CarsModels> cars = [];

    // query to supabase
    final res = await supabase.from('cars').select();
    // print("res: $res");
    if (res.isEmpty) {
      print("Data kosong");
      return cars;
    }
    for (var row in res as List) {
      cars.add(CarsModels.fromJson(row));
    }
    return cars;
  }

  // service to get all car data schedule

  Future<List<CarsModels>> getScheduleData({
    required String carFrom,
    required String carTo,
    required DateTime carDate,
  }) async {
    List<CarsModels> scheduledCar = [];
    DateTime startOfDay = DateTime(carDate.year, carDate.month, carDate.day);
    DateTime startOfNextDay = startOfDay.add(const Duration(days: 1));

    String startOfDayStr = startOfDay.toIso8601String();
    String startOfNextDayStr = startOfNextDay.toIso8601String();

    try {
      final resCars = await supabase
          .from('cars')
          .select(
              'id, car_logo,car_name,car_class,car_time_date_from,car_from,car_to,available_seats,car_desc,car_price,car_date,seats,owner_car,latitude,longitude,include_driver,facility1,facility2,facility3,facility4,facility5,include_key, tickets!left(selected_passengers, created_at)')
          .eq('car_from', carFrom)
          .eq('car_to', carTo)
          .gte('car_time_date_from', startOfDayStr)
          .lt('car_time_date_from', startOfNextDayStr);

      // print("response from supabase: $resCars");
      if (resCars.isEmpty) {
        print('No car schedule available');
        return scheduledCar;
      }

      // Parse the results and add to scheduledCar
      for (var row in resCars as List) {
        int availableSeats = row['available_seats'];
        int totalSelectedSeats = row['tickets'] != null
            ? row['tickets'].where((ticket) {
                DateTime createdAt = DateTime.parse(ticket['created_at']);
                return createdAt.isAfter(startOfDay) &&
                    createdAt.isBefore(startOfNextDay);
              }).fold(0, (sum, ticket) => sum + ticket['selected_passengers'])
            : 0;
        int availableSeatsAfterBooking = availableSeats - totalSelectedSeats;

        print('Car ID: ${row['id']}');
        print('Available Seats: $availableSeats');
        print('Total Selected Seats: $totalSelectedSeats');
        print('Available Seats After Booking: $availableSeatsAfterBooking');

        if (availableSeatsAfterBooking > 0) {
          row['available_seats'] = availableSeatsAfterBooking;
          scheduledCar.add(CarsModels.fromJson(row));
        }
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return scheduledCar;
  }
}
