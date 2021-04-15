
import 'package:booking/common/widgets.dart';
import 'package:flutter/material.dart';

class SearchQuery {
  final int people;
  final String place;

  SearchQuery(this.people, this.place);
}

class AccommodationListScreen extends StatefulWidget {
  static const ROUTE = "/accommodations";
  final SearchQuery searchQuery;

  const AccommodationListScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  _AccommodationListScreenState createState() =>
      _AccommodationListScreenState();
}

class _AccommodationListScreenState extends State<AccommodationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [AccountButton()],
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          title: Text("VYHLADAVANIE"),
        ),
        body: SafeArea(
          child: Container(
            child: Text('Listing: ${widget.searchQuery.place}'),
          ),
        ));
  }
}
