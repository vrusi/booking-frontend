import 'dart:convert';

import 'package:http/http.dart' as http;

class Api extends http.BaseClient {
  final http.Client _inner = http.Client();
  final String baseUrl;

  Api({this.baseUrl = "localhost:8000"});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request);
  }

  Future<List<Accommodation>> getAccommodations(
      {int? people, String? place}) async {
    final response = await this.get(Uri.http(baseUrl, "/accommodation/"));

    if (response.statusCode == 200) {
      print(response.body);
      return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
          .map((json) => Accommodation.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}

class Accommodation {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String address;
  final int maxOccupants;
  final double? rating;
  final int ratingCount;

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        images: (json['images'] as List).map((e) => e as String).toList(),
        address: json['location']['address'],
        maxOccupants: json['occupant_count'],
        rating: json['rating']['average'],
        ratingCount: json['rating']['count']);
  }

  Accommodation(
      {required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.address,
      required this.maxOccupants,
      required this.rating,
      required this.ratingCount});
}
