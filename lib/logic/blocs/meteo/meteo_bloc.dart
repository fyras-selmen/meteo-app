import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meteo_app/data/cache/cache_manager.dart';
import 'package:meteo_app/data/models/cities.dart';
import 'package:meteo_app/data/models/meteo.dart';
import 'package:meteo_app/data/repositories/meteo_repository.dart';

part 'meteo_event.dart';
part 'meteo_state.dart';

class MeteoBloc extends Bloc<MeteoEvent, MeteoState> {
  MeteoBloc() : super(const MeteoState()) {
    on<MeteoEvent>((event, emit) async {
      final MeteoRepository meteoRepository = MeteoRepository();
      if (event is FetchMeteoEvent) {
        try {
          final meteo = await meteoRepository.getMeteo(event.lat, event.long);
          meteo!.city = event.city;
          return emit(state.copyWith(
            status: MeteoStatus.success,
            data: meteo,
          ));
        } catch (e) {
          emit(state.copyWith(
            status: MeteoStatus.error,
          ));
          log("MeteoEvent Exception :$e");
        }
      } else if (event is FetchCitiesEvent) {
        List<Meteo> cities = [];
        if (await CacheManager.containsKey("cities")) {
          var oldCitiesRaw = await CacheManager.getData("cities");

          cities = cityListFromJson(jsonDecode(oldCitiesRaw.syncData));

          emit(state.copyWith(favoriteCities: cities));
        } else {
          emit(state.copyWith(favoriteCities: [], status: MeteoStatus.success));
        }
      } else if (event is AddCityEvent) {
        List<Meteo> cities = [];
        if (await CacheManager.containsKey("cities")) {
          var oldCitiesRaw = await CacheManager.getData("cities");
          cities = cityListFromJson(jsonDecode(oldCitiesRaw.syncData));
        }
        bool alreadyExist = false;
        for (var element in cities) {
          if (element.city == state.data!.city) {
            alreadyExist = true;
          }
        }
        if (alreadyExist) {
          await Fluttertoast.showToast(
              msg: "City already saved",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.5),
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          cities.add(state.data!);
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: "cities", syncData: jsonEncode(cities));
          bool done = await CacheManager.setData("cities", cacheDBModel);
          if (done) {
            await Fluttertoast.showToast(
                msg: "City saved",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black.withOpacity(0.5),
                textColor: Colors.white,
                fontSize: 16.0);
            emit(state.copyWith(favoriteCities: cities));
          }
        }
      } else if (event is DeleteCityEvent) {
        add(const FetchCitiesEvent());
        List<Meteo> newCities = [];
        for (var city in state.favoriteCities!) {
          if (city.city != event.city) {
            newCities.add(city);
          }
        }
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: "cities", syncData: jsonEncode(newCities));
        bool done = await CacheManager.setData("cities", cacheDBModel);
        if (done) {
          await Fluttertoast.showToast(
              msg: "City deleted",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black.withOpacity(0.5),
              textColor: Colors.white,
              fontSize: 16.0);
          emit(state.copyWith(favoriteCities: newCities));
        }
      }
    });
  }

  String getWeatherCondition(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return "Clear sky";
      case 1:
        return "Mainly clear";
      case 2:
        return "partly cloudy";
      case 3:
        return "overcast";
      case 45:
      case 48:
        return "Fog and depositing rime fog";
      case 51:
        return "Drizzle: Light";
      case 53:
        return "Drizzle: moderate";
      case 55:
        return "Drizzle: dense intensity";
      case 56:
        return "Freezing Drizzle: Light";
      case 57:
        return "Freezing Drizzle: dense intensity";
      case 61:
        return "Rain: Slight";
      case 63:
        return "Rain: moderate";
      case 65:
        return "Rain : heavy intensity";
      case 66:
        return "Freezing Rain: Light";
      case 67:
        return "Freezing Rain: heavy intensity";
      case 71:
        return "Snow fall: Slight";
      case 73:
        return "Snow fall: moderate";
      case 75:
        return "Snow fall: heavy intensity";
      case 77:
        return "Snow grains";
      case 80:
        return "Rain showers: Slight";
      case 81:
        return "Rain showers: moderate";
      case 82:
        return "Rain showers: violent";
      case 85:
        return "Snow showers: Slight";
      case 86:
        return "Snow showers: heavy";
      case 95:
        return "Thunderstorm: Slight or moderate";
      case 96:
      case 99:
        return "Thunderstorm with slight and heavy hail";
      default:
        return "";
    }
  }
}
