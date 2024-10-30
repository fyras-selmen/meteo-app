part of 'meteo_bloc.dart';

sealed class MeteoEvent extends Equatable {
  const MeteoEvent();
}

class FetchMeteoEvent extends MeteoEvent {
  final double long;
  final double lat;
  final String city;
  const FetchMeteoEvent(
      {required this.long, required this.lat, required this.city});

  @override
  List<Object?> get props => [long, lat];
}

class FetchCitiesEvent extends MeteoEvent {
  const FetchCitiesEvent();

  @override
  List<Object?> get props => [];
}

class AddCityEvent extends MeteoEvent {
  const AddCityEvent();

  @override
  List<Object?> get props => [];
}

class DeleteCityEvent extends MeteoEvent {
  final String city;
  const DeleteCityEvent({required this.city});

  @override
  List<Object?> get props => [city];
}
