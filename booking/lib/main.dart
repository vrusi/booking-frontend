import 'package:flutter/material.dart';

import 'accommodationlist/accommodation_list_screen.dart';
import 'common/widgets.dart';
import 'landing/landing_screen.dart';

void main() {
  runApp(BookingApp());
}

class BookingApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        }
      },
    );
  }
}