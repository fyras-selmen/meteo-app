import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meteo_app/data/dataProviders/my_dio.dart';

class MeteoAPI {
  Future<dynamic> getRawMeteo(double lat, double long) async {
    try {
      var response = await dio.get(
        ('/forecast?latitude=$lat&longitude=$long&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m&hourly=temperature_2m&forecast_days=1'),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        await Fluttertoast.showToast(
            msg: "No data found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        log("No data found for this city");
        return "";
      } else {
        await Fluttertoast.showToast(
            msg: "Failed to load data. Please try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        log("Error RawMeteo API");
        return "";
      }
    } catch (exception) {
      log("RowMeteoException : $exception");
    }
  }

  Future<dynamic> searchCities(String keyword) async {
    try {
      var response = await dio1.get(
        ('/search?name=$keyword&format=json&language=en&count=10'),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 404) {
        log("No data found for this city");
        return "";
      } else {
        log("Error SearchCities API");
        return "";
      }
    } catch (exception) {
      log("RowSearchCities Exception : $exception");
    }
  }
}
