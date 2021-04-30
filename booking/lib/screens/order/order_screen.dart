import 'package:booking/api/api_client.dart';
import 'package:booking/common/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'order_successful.dart';

class OrderScreen extends StatefulWidget {
  static const ROUTE = "/order";
  final Accommodation accommodation;

  const OrderScreen({Key? key, required this.accommodation}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Card(
                child: Container(
                  height: 300,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(accommodation.images[1])),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Common.rating(context, accommodation),
                              SizedBox(
                                height: 8.0,
                              ),
                              Common.title(accommodation),
                              SizedBox(
                                height: 6.0,
                              ),
                              Common.pricing(context, accommodation)
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SPOLU K ÚHRADE", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(accommodation.price.toStringAsPrecision(accommodation.price.toString().length) + " €",
                  style: TextStyle(fontWeight: FontWeight.bold))
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, OrderSuccessfulScreen.ROUTE,
                        arguments: accommodation);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0),
                        child: Text("ZAPLATIŤ"),
                  ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        )
                      )
                    ),
                  )
                ],

            ),

          ],
        )));
  }
}
