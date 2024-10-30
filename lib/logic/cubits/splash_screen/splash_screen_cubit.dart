import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo_app/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo_app/logic/cubits/internet/internet_cubit.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(const SplashScreenLoading()) {
    KiwiContainer kc = KiwiContainer();

    final InternetCubit internetCubit = kc.resolve("internetCubit");
    final MeteoBloc meteoBloc = kc.resolve("meteoBloc");

    try {
      internetCubit.stream.listen((event) async {
        if (event is InternetConnected) {
          var currentLocation = await getCurrentLocation();
          if (currentLocation != null) {
            var city = await getCityName(
                currentLocation.longitude, currentLocation.latitude);
            meteoBloc.add(FetchMeteoEvent(
                city: city,
                long: currentLocation.longitude,
                lat: currentLocation.latitude));
          }
          meteoBloc.add(const FetchCitiesEvent());
          meteoBloc.stream.listen((state) async {
            if (state.status == MeteoStatus.success) {
              emit(const SplashScreenLoaded());
              Get.offNamed("/home");
            } else if (state.status == MeteoStatus.error) {
              await Fluttertoast.showToast(
                  msg: "Failed to load data. Please try again.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Get.offNamed("/home");
            }
          });
        } else {
          emit(const SplashScreenLoading());
        }
      });
    } catch (exception) {
      log(exception.toString());
    }
  }
  Future<String> getCityName(double long, double lat) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );

    return placemarks[0].locality ?? "";
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}
