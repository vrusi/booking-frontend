import 'dart:io';

import 'package:booking/api/api_client.dart';
import 'package:booking/screens/accommodationdetail/accommodation_detail_screen.dart';
import 'package:booking/screens/accommodationlist/accommodation_list_screen.dart';
import 'package:booking/screens/landing/landing_screen.dart';
import 'package:booking/screens/login/login_screen.dart';
import 'package:booking/screens/order/order_screen.dart';
import 'package:booking/screens/order/order_successful.dart';
import 'package:booking/screens/profile/profile_screen.dart';
import 'package:booking/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  var api = Api(
      baseUrl: Platform.isAndroid ? "10.0.2.2:8000" : "localhost:8000",
      sharedPreferences: sharedPreferences);
  GetIt.instance.registerSingleton<Api>(api);

  print(api.getUser()?.email);
  print(api.getUser()?.token);
  runApp(BookingApp());
}

class BookingApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      initialRoute: LandingScreen.ROUTE,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LandingScreen.ROUTE:
            return MaterialPageRoute(builder: (_) => LandingScreen());
          case AccommodationListScreen.ROUTE:
            return MaterialPageRoute(
              builder: (_) => AccommodationListScreen(
                  searchQuery: settings.arguments as SearchQuery),
            );
          case AccommodationDetailScreen.ROUTE:
            return MaterialPageRoute(
                builder: (_) => AccommodationDetailScreen(
                      accommodation: settings.arguments as Accommodation,
                    ));
          case LoginScreen.ROUTE:
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case RegisterScreen.ROUTE:
            return MaterialPageRoute(builder: (_) => RegisterScreen());
          case ProfileScreen.ROUTE:
            return MaterialPageRoute(builder: (_) => ProfileScreen());
          case OrderScreen.ROUTE:
            return MaterialPageRoute(
                builder: (_) => OrderScreen(
                    accommodation: settings.arguments as Accommodation));
          case OrderSuccessfulScreen.ROUTE:
            return MaterialPageRoute(builder: (_) => OrderSuccessfulScreen(
              accommodation: settings.arguments as Accommodation
            ));
        }
      },
    );
  }
}
