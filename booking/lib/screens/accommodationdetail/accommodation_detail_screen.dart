import 'package:booking/api/api_client.dart';
import 'package:booking/common/widgets.dart';
import 'package:booking/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:booking/screens/review/review_screen.dart';
import 'package:get_it/get_it.dart';

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
  var api = GetIt.instance.get<Api>();

  bool loading = true;
  Accommodation? accommodation;

  @override
  void initState() {
    loadAccommodation();
    super.initState();
  }

  void loadAccommodation() async {
    try {
      setState(() {
        loading = true;
      });
      accommodation = await api.getAccommodation(widget.accommodation.id);
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [AccountButton()],
          centerTitle: false,
          title: Text("VYHĽADÁVANIE"),
        ),
        body: SafeArea(
          bottom: false,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
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
                                  image:
                                      NetworkImage(accommodation!.images[1])),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Common.title(accommodation!,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Common.rating(context, accommodation!),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Common.pricing(context, accommodation!),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Text(accommodation!.address),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 16.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: accommodation!.utilities.length,
                                  itemBuilder: (context, itemIndex) {
                                    if (itemIndex ==
                                        accommodation!.utilities.length - 1) {
                                      return Text(
                                          accommodation!.utilities[itemIndex]);
                                    } else {
                                      return Text(
                                          accommodation!.utilities[itemIndex] +
                                              " · ");
                                    }
                                  }),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 6.0),
                            child: Text(
                              accommodation!.description,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Divider(),
                          _reviews(context, accommodation!),
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
                              bottom:
                                  MediaQuery.of(context).viewPadding.bottom),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, OrderScreen.ROUTE,
                                    arguments: accommodation);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60.0),
                                    child: Text("REZERVOVAŤ"),
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
    if (accommodation.reviews.isEmpty) return [Text("Zatiaľ žiadne recenzie")];

    var userName = api.getUser()?.email;

    return accommodation.reviews
        .map((review) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.author,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (review.author == userName)
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    var success = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ReviewScreen(
                                                  accommodation:
                                                      widget.accommodation,
                                                  existingReview: review,
                                                )));

                                    loadAccommodation();
                                  }),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    var success = await api.deleteReview(
                                        accommodation.id, review.id);
                                    loadAccommodation();
                                    if (success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Vaša recenzia bola zmazaná.")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Recenziu sa nepodarilo zmazať.")));
                                    }
                                  }),
                            ],
                          )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(review.review),
                  ),
                  if (review.image != null)
                    Image.network(
                      "http://" + api.baseUrl + "/" + review.image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  Divider()
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
                      onPressed: () async {
                        if (api.getUser() == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Pre pridanie recenzie musíte byť prihlásení")));
                        } else {
                          var success = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ReviewScreen(
                                      accommodation: widget.accommodation)));
                          loadAccommodation();
                        }
                      },
                      child: Text("Napísať recenziu"),
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
