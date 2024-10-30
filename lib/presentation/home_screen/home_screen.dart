import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo_app/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo_app/presentation/home_screen/widgets/current_weather_widget.dart';
import 'package:meteo_app/presentation/home_screen/widgets/hourly_forcast.dart';
import 'package:meteo_app/presentation/home_screen/widgets/my_drawer.dart';
import 'package:meteo_app/presentation/home_screen/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData? locationData;
  bool isSearching = false;
  bool isDrawerOpen = false;
  bool noData = true;
  final MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        setState(() {
          isDrawerOpen = isOpened;
        });
      },
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: !isSearching,
        actions: isSearching
            ? []
            : [
                IconButton(
                    onPressed: () {
                      meteoBloc.add(const AddCityEvent());
                    },
                    icon: const Icon(
                      Icons.favorite,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                    icon: const Icon(Icons.search))
              ],
        title: isSearching
            ? Stack(
                alignment: Alignment.centerRight,
                children: [
                  const SearchCityBar(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = false;
                        });
                      },
                      icon: const Icon(Icons.close))
                ],
              )
            : BlocBuilder<MeteoBloc, MeteoState>(
                builder: (context, state) {
                  if (state.data == null) {
                    return const Text("Weather");
                  }

                  return Text(state.data!.city!.isEmpty
                      ? "Weather"
                      : state.data!.city!);
                },
              ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black.withOpacity(0.5),
        child: const MyDrawer(),
      ),
      /* appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(" Weather app"),
      ), */
      body: BlocBuilder<MeteoBloc, MeteoState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: state.data == null
                  ? SizedBox(
                      height: ScreenUtil().screenHeight,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            "Search for a city to view its weather.",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                      ),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                            sigmaX: isSearching || isDrawerOpen ? 3 : 0,
                            sigmaY: isSearching || isDrawerOpen ? 3 : 0),
                        child: Column(
                          children: [
                            CurrentWeatherWidget(
                              humidty: state.data!.current.humidity,
                              temperature: state.data!.current.temperature,
                              weatherCondition: state.data!.current.weatherCode,
                              windSpeed: state.data!.current.windSpeed,
                              windDireciton: state.data!.current.windDirection,
                            ),
                            HourlyForcast(
                                temperatures: state.data!.hourly.temperature,
                                times: state.data!.hourly.time),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
