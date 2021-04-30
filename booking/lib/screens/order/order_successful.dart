import 'package:booking/api/api_client.dart';
import 'package:booking/common/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  static const ROUTE = "/ordersuccess";
  final Accommodation accommodation;

  const OrderSuccessfulScreen({Key? key, required this.accommodation})
      : super(key: key);

  @override
  _OrderSuccessfulState createState() => _OrderSuccessfulState();
}

class _OrderSuccessfulState extends State<OrderSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    final accommodation = widget.accommodation;

    return Scaffold(
        appBar: AppBar(
          actions: [AccountButton()],
          centerTitle: false,
          title: Text("REZERVÁCIA"),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 120.0),
                child: Center(
                  child: Text(
                      "Ďakujeme za rezerváciu. " +
                          accommodation.title +
                          " už na Vás čaká!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      )),
                )),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Naspäť na vyhľadávanie ubytovaní"),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                ))
          ],
        )));
  }
}
