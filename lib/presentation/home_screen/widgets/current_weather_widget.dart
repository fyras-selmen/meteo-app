// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo_app/logic/blocs/meteo/meteo_bloc.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final double temperature;
  final int weatherCondition;
  final int windDireciton;
  final int humidty;
  final double windSpeed;
  const CurrentWeatherWidget(
      {super.key,
      required this.temperature,
      required this.weatherCondition,
      required this.windSpeed,
      required this.humidty,
      required this.windDireciton});

  @override
  Widget build(BuildContext context) {
    final MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: ScreenUtil().scaleHeight * 90,
                    width: ScreenUtil().scaleWidth * 90,
                    child: Image.asset(
                      "assets/icons/${getWeatherIcon(weatherCondition)}.png",
                      fit: BoxFit.fill,
                    )),
                Column(
                  children: [
                    Text(
                      " ${meteoBloc.getWeatherCondition(weatherCondition)}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "${temperature.ceil()}°C",
                      style: const TextStyle(fontSize: 34),
                    )
                  ],
                )
              ],
            )),
        Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: ScreenUtil().scaleHeight * 90,
                    width: ScreenUtil().scaleWidth * 90,
                    child: Image.asset(
                      "assets/icons/windy.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getWindDirection(windDireciton),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "${windSpeed.ceil()} km/h",
                        style: const TextStyle(fontSize: 34),
                      )
                    ],
                  ),
                ],
              ),
            )),
        Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withOpacity(0.4))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: ScreenUtil().scaleHeight * 90,
                    width: ScreenUtil().scaleWidth * 90,
                    child: Image.asset(
                      "assets/icons/humidity.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Humidity",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "$humidty%",
                        style: const TextStyle(fontSize: 34),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String getWindDirection(degree) {
    if (degree > 337.5) return 'Northerly';
    if (degree > 292.5) return 'North Westerly';
    if (degree > 247.5) return 'Westerly';
    if (degree > 202.5) return 'South Westerly';
    if (degree > 157.5) return 'Southerly';
    if (degree > 122.5) return 'South Easterly';
    if (degree > 67.5) return 'Easterly';
    if (degree > 22.5) {
      return 'North Easterly';
    }
    return 'Northerly';
  }

  String getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return "0";
      case 1:
        return "1";
      case 2:
        return "2";
      case 3:
        return "3";
      case 45:
        return "45";
      case 48:
        return "45";
      case 51:
        return "51";
      case 53:
        return "51";
      case 55:
        return "51";
      case 56:
        return "51";
      case 57:
        return "51";
      case 61:
        return "80";
      case 63:
        return "80";
      case 65:
        return "80";
      case 66:
        return "22";
      case 67:
        return "22";
      case 71:
        return "73";
      case 73:
        return "73";
      case 75:
        return "73";
      case 77:
        return "73";
      case 80:
        return "80";
      case 81:
        return "80";
      case 82:
        return "80";
      case 85:
        return "73";
      case 86:
        return "73";
      case 95:
        return "95";
      case 96:
        return "95";
      case 99:
        return "95";

      default:
        return "logo";
    }
  }
}
