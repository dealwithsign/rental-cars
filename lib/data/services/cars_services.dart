// data/services/cars_services.dart
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cars_model.dart';

class CarsServices {
  final supabase = Supabase.instance.client;

  Future<List<CarsModels>> getAllCars() async {
    final res = await supabase.from('cars').select();
    if (res.isEmpty) {
      print("Data kosong");
      return [];
    }
    return (res as List).map((row) => CarsModels.fromJson(row)).toList();
  }

  Future<List<CarsModels>> getScheduleData({
    required String carFrom,
    required String carTo,
    required DateTime carDate,
  }) async {
    DateTime startOfDay = DateTime(carDate.year, carDate.month, carDate.day);
    DateTime startOfNextDay = startOfDay.add(const Duration(days: 1));

    String startOfDayStr = startOfDay.toIso8601String();
    String startOfNextDayStr = startOfNextDay.toIso8601String();

    try {
      final resCars = await supabase
          .from('cars')
          .select(
              'id, car_logo,car_name,car_class,car_time_date_from,car_from,car_to,available_seats,car_desc,car_price,car_date,seats,owner_car,latitude,longitude,include_driver,facility1,facility2,facility3,facility4,facility5,include_key, tickets!left(selected_passengers, created_at,car_date)')
          .eq('car_from', carFrom)
          .eq('car_to', carTo)
          .gte('car_date', startOfDayStr)
          .lt('car_date', startOfNextDayStr);

      if (resCars.isEmpty) {
        print('No car schedule available');
        return [];
      }

      return (resCars as List)
          .where((row) {
            int availableSeats = row['available_seats'];
            int totalSelectedSeats = row['tickets'] != null
                ? row['tickets'].where((ticket) {
                    DateTime createdAt = DateTime.parse(ticket['created_at']);
                    return createdAt.isAfter(startOfDay) &&
                        createdAt.isBefore(startOfNextDay);
                  }).fold(
                    0, (sum, ticket) => sum + ticket['selected_passengers'])
                : 0;
            int availableSeatsAfterBooking =
                availableSeats - totalSelectedSeats;

            // Debug statements
            print('Car ID: ${row['id']}');
            print('Available Seats: $availableSeats');
            print('Total Selected Seats: $totalSelectedSeats');
            print('Available Seats After Booking: $availableSeatsAfterBooking');

            if (availableSeatsAfterBooking > 0) {
              row['available_seats'] = availableSeatsAfterBooking;
              return true;
            }
            return false;
          })
          .map((row) => CarsModels.fromJson(row))
          .toList();
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }
}
