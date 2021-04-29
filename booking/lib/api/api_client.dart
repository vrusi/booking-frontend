import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String token;
  final String email;

  User({required this.token, required this.email});

  String toJson() {
    return jsonEncode({"token": this.token, "email": this.email});
  }

  factory User.fromJson(String json) {
    var jsonDecoded = jsonDecode(json);

    return User(token: jsonDecoded['token'], email: jsonDecoded['email']);
  }
}

class Api extends http.BaseClient {
  final http.Client _inner = http.Client();
  final String baseUrl;
  final SharedPreferences sharedPreferences;

  Api({required this.sharedPreferences, required this.baseUrl});

  User? getUser() {
    var user = sharedPreferences.getString('user');
    if (user == null) return null;

    return User.fromJson(user);
  }

  Future<void> setUser(User? user) async {
    if (user == null)
      sharedPreferences.remove('user');
    else {
      await sharedPreferences.setString('user', user.toJson());
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    var user = getUser();

    if (user != null) {
      request.headers['Authorization'] = 'Bearer ${user.token}';
    }
    return _inner.send(request);
  }

  Future<bool> addReview(String accomodationId, String ratingText,
      double rating, File? image) async {
    try {
      var uri = Uri.http(baseUrl, "/accommodation/${accomodationId}/rating/");
      var request = http.MultipartRequest("POST", uri);

      var user = getUser();
      request.headers['Authorization'] = 'Bearer ${user!.token}';
      request.fields['rating'] = rating.toInt().toString();
      request.fields['title'] = "something";
      request.fields['text'] = ratingText;

      if (image != null) {
        request.files.add(http.MultipartFile.fromBytes(
            'image', image.readAsBytesSync(),
            filename: "image.jpg", contentType: MediaType('image', 'jpg')));
      }

      var response = await request.send();
      print(response.statusCode);
      print(request.headers);
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await this.post(Uri.http(baseUrl, "/auth/register/"),
          body: jsonEncode({
            "username": email,
            "email": email,
            "firstName": "Something",
            "lastName": "Something",
            "password": password
          }));

      var token = jsonDecode(response.body)['token'];
      await setUser(User(token: token, email: email));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await this.post(Uri.http(baseUrl, "/auth/login/"),
          body: jsonEncode({"username": email, "password": password}));

      var token = jsonDecode(response.body)['token'];

      await setUser(User(token: token, email: email));

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Accommodation> getAccommodation(String id) async {
    try {
      final response =
          await this.get(Uri.http(baseUrl, "/accommodation/${id}"));
      if (response.statusCode == 200) {
        return Accommodation.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      throw Exception('Failed to load');
    }
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

class Review {
  final String author;
  final String review;
  final String? image;

  Review({required this.author, required this.review, this.image});
}

class Accommodation {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String address;
  final int maxOccupants;
  final double? rating;
  final double price;
  final int ratingCount;
  final List<String> utilities;
  final List<Review> reviews;

  factory Accommodation.fromJson(Map<String, dynamic> json) {

    return Accommodation(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        images: (json['images'] as List).map((e) => e as String).toList(),
        address: json['location']['address'],
        maxOccupants: json['occupant_count'],
        rating: json['rating']['average'],
        ratingCount: json['rating']['count'],
        price: 55.0,
        utilities: ["4 hostia", "1 spalna", "3 postele", "1 kupelna"],
        reviews: (json['rating']['ratings'] as List)
            .map((e) =>
                Review(author: e['author']['username'], review: e['content'], image: e['image']))
            .toList());
  }

  Accommodation(
      {required this.reviews,
      required this.utilities,
      required this.price,
      required this.id,
      required this.title,
      required this.description,
      required this.images,
      required this.address,
      required this.maxOccupants,
      required this.rating,
      required this.ratingCount});
}
