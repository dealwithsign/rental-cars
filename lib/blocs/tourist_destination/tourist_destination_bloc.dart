// blocs/tourist_destination/tourist_destination_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rents_cars_app/blocs/tourist_destination/tourist_destination_state.dart';
import 'package:rents_cars_app/data/services/tourist_destination.dart';

import 'tourist_destination_event.dart';

class TouristDestinationBloc
    extends Bloc<TouristDestinationEvent, TouristDestinationState> {
  final TouristDestinationServices touristDestinationServices;

  TouristDestinationBloc(this.touristDestinationServices)
      : super(TouristDestinationInitial()) {
    // fetch tourist destination
    on<FetchTouristDestinationEvent>(
      (event, emit) async {
        emit(TouristDestinationLoading());
        try {
          final touristDestination =
              await touristDestinationServices.getAllTouristDestinations();
          print(touristDestination);
          emit(TouristDestinationSuccess(touristDestination));
        } catch (e) {
          emit(TouristDestinationError(e.toString()));
        }
      },
    );
  }
}
