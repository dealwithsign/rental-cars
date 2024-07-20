import 'package:rents_cars_app/models/cars.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CarsServices {
  final supabase = Supabase.instance.client;

  // services to get all cars
  Future<List<CarsModels>> getAllCars() async {
    List<CarsModels> cars = [];

    // query to supabase
    final res = await supabase.from('cars').select();
    print("res: $res");
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
    DateTime startOfNextDay = startOfDay.add(Duration(days: 1));
    final res = await supabase
        .from('cars')
        .select()
        .eq('car_from', carFrom)
        .eq('car_to', carTo)
        .gte('car_time_date_from', startOfDay.toIso8601String())
        .lt('car_time_date_from', startOfNextDay.toIso8601String());
    print("response from supabase: $res");
    if (res.isEmpty) {
      print('No car schedule available');
      return scheduledCar;
    }
    for (var row in res as List) {
      scheduledCar.add(CarsModels.fromJson(row));
    }
    return scheduledCar;
  }
}
