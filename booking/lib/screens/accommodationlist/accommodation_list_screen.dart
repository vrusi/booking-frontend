import 'package:booking/api/api_client.dart';
import 'package:booking/common/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  final Api _api = GetIt.instance.get<Api>();
  List<Accommodation>? accommodations;
  bool loading = false;
  String? error;

  @override
  void initState() {
    fetchAccommodations();
    super.initState();
  }

  void fetchAccommodations() async {
    try {
      accommodations = await _api.getAccommodations();
      error = null;
    } catch (e, st) {
      print(e.toString());
      print(st);
      setState(() {
        error = "Ooops, nepodarilo sa nacitat ubytovania!";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

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
          child: Column(
            children: [
              _searchQueryInfo(context),
              Expanded(child: loading ? _loading() : _list())
            ],
          ),
        ));
  }

  Padding _searchQueryInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Container(
          color: Colors.pinkAccent,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${widget.searchQuery.place}, ${widget.searchQuery.people} ludia",
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _list() {
    if (error != null)
      return Center(
        child: Text(error!),
      );
    if (accommodations == null) return Container();

    return ListView.builder(
        itemCount: accommodations!.length,
        itemBuilder: (BuildContext context, int itemIndex) {
          final accommodation = accommodations![itemIndex];
          return Padding(
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
                      child: Image.network(
                        accommodation.images[1],
                        height: 300.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      child: Text(accommodation.title),
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
