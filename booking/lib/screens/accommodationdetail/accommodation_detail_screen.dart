import 'package:booking/api/api_client.dart';
import 'package:booking/common/widgets.dart';
import 'package:flutter/material.dart';

class AccommodationDetailScreen extends StatefulWidget {
  static const ROUTE = "/accommodationdetail";

  final Accommodation accommodation;

  const AccommodationDetailScreen({Key? key, required this.accommodation})
      : super(key: key);

  @override
  _AccommodationDetailScreenState createState() =>
      _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final accommodation = widget.accommodation;

    return Scaffold(
        appBar: AppBar(
          actions: [AccountButton()],
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          centerTitle: false,
          title: Text("VYHLADAVANIE"),
        ),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(accommodation.images[1])),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Common.title(accommodation,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Common.rating(context, accommodation),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Common.pricing(context, accommodation),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Text(accommodation.address),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 16.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: accommodation.utilities.length,
                            itemBuilder: (context, itemIndex) {
                              if (itemIndex ==
                                  accommodation.utilities.length - 1) {
                                return Text(accommodation.utilities[itemIndex]);
                              } else {
                                return Text(
                                    accommodation.utilities[itemIndex] + " · ");
                              }
                            }),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Text(
                        accommodation.description,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Divider(),
                    _reviews(context, accommodation),
                    SizedBox(
                      height: 160.0,
                    )
                  ],
                ),
              ),
              Positioned(
                child: Container(
                  color: Colors.white,
                  height: 100.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60.0),
                              child: Text("REZERVOVAT"),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                            ))
                      ],
                    ),
                  ),
                ),
                bottom: 0,
                left: 0,
                right: 0,
              )
            ],
          ),
        ));
  }

  List<Widget> _allReviews(Accommodation accommodation) {
    if (accommodation.reviews.isEmpty) return [Text("Ziadne recenzie")];

    return accommodation.reviews
        .map((review) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.author,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(review.review)
                ],
              ),
            ))
        .toList();
  }

  Widget _reviews(BuildContext context, Accommodation accommodation) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recenzie",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton(
                      onPressed: () {},
                      child: Text("Napisat recenziu"),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ))
                ],
              ),
              SizedBox(
                height: 16.0,
              )
            ] +
            _allReviews(accommodation),
      ),
    );
  }
}
