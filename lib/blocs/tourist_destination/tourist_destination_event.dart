// blocs/tourist_destination/tourist_destination_event.dart
abstract class TouristDestinationEvent {}

class FetchTouristDestinationEvent extends TouristDestinationEvent {}

class LoadTouristDestination extends TouristDestinationEvent {}
