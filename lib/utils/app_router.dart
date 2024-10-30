import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo_app/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo_app/presentation/home_screen/home_screen.dart';
import 'package:meteo_app/presentation/splash_screen/splash_screen.dart';

class AppRouter {
  final MeteoBloc _meteoBloc = KiwiContainer().resolve("meteoBloc");
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/home":
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _meteoBloc,
                  child: const HomeScreen(),
                ));

      default:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _meteoBloc, child: const SplashScreen()));
    }
  }

  void dispose() {
    _meteoBloc.close();
  }
}
