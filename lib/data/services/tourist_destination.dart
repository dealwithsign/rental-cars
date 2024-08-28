// data/services/tourist_destination.dart
import 'package:rents_cars_app/data/models/touristdestination_model.dart';
import 'package:rents_cars_app/data/models/touristdestination_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TouristDestinationServices {
  final supabase = Supabase.instance.client;

  // Get all tourist destinations
  Future<List<TouristdestinationModel>> getAllTouristDestinations() async {
    try {
      final res = await supabase.from('tourist_destinations').select();
      if (res.isEmpty) {
        print("Data kosong");
        return [];
      }
      return (res as List)
          .map((row) => TouristdestinationModel.fromJson(row))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
