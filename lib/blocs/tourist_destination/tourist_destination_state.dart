// blocs/tourist_destination/tourist_destination_state.dart

import '../../data/models/touristdestination_model.dart';

abstract class TouristDestinationState {}

class TouristDestinationInitial extends TouristDestinationState {}

class TouristDestinationLoading extends TouristDestinationState {}

class TouristDestinationSuccess extends TouristDestinationState {
  final List<TouristdestinationModel> touristDestination;
  TouristDestinationSuccess(this.touristDestination);
}

class TouristDestinationError extends TouristDestinationState {
  final String message;
  TouristDestinationError(this.message);
}
