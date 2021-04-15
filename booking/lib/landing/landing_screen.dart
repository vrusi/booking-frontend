import 'package:booking/accommodationlist/accommodation_list_screen.dart';
import 'package:booking/common/widgets.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LandingScreen extends StatefulWidget {
  static const ROUTE = "/";

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const places = ["Kosice", "Bratislava", "Zilina"];

  String? place = "Kosice";
  int? people = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('BOOKING'),
        actions: [AccountButton()],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('Kam idete?'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search),
                    ),
                    DropdownButton<String>(
                      value: place,
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          place = newValue;
                        });
                      },
                      items:
                          places.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            child: Text(value),
                            width: screenWidth * 0.6,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Text(
                      'Kolki idete?',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.people),
                    ),
                    DropdownButton<int>(
                      value: people,
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          people = newValue;
                        });
                      },
                      items:
                          Iterable<int>.generate(10).toList().map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Container(
                            child: Text(value.toString()),
                            width: screenWidth * 0.6,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AccommodationListScreen.ROUTE,
                            arguments: SearchQuery(people!, place!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Text("Vyhladat ubytovanie"),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
