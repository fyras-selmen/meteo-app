import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo_app/data/dataProviders/my_dio.dart';
import 'package:meteo_app/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo_app/logic/cubits/internet/internet_cubit.dart';
import 'package:meteo_app/logic/cubits/splash_screen/splash_screen_cubit.dart';
import 'package:meteo_app/presentation/splash_screen/splash_screen.dart';
import 'package:meteo_app/utils/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  configureDio();
  configureDio2();
  KiwiContainer kc = KiwiContainer();
  kc.registerSingleton((c) => MeteoBloc(), name: 'meteoBloc');
  kc.registerSingleton((c) => SplashScreenCubit(), name: 'splashScreenCubit');
  kc.registerSingleton((c) => InternetCubit(), name: 'internetCubit');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/icons/logo.png"), context);
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      theme: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.white, backgroundColor: Colors.white),
        primaryColor: Colors.blue,
        fontFamily: "Inter",
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
      home: const SplashScreen(),
    );
  }
}
