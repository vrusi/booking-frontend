import 'dart:io';

import 'package:booking/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ReviewScreen extends StatefulWidget {
  final Accommodation accommodation;
  final Review? existingReview;

  static const ROUTE = "/review";

  const ReviewScreen(
      {Key? key, required this.accommodation, this.existingReview})
      : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final picker = ImagePicker();
  final Api _api = GetIt.instance.get<Api>();

  double rating = 0;
  final TextEditingController ratingText = TextEditingController();
  File? _image;

  @override
  void initState() {
    rating = widget.existingReview?.rating ?? 0;
    ratingText.text = widget.existingReview?.review ?? "";
    super.initState();
  }

  @override
  void dispose() {
    ratingText.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 60, maxWidth: 1000);

    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
        _image = File(pickedFile.path);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("RECENZIA"),
        centerTitle: false,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.accommodation.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text("Slovné hodnotenie"),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: ratingText,
                          maxLines: 8,
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            hintText: 'Páčilo sa mi...',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text("Počet hviezdičiek"),
                        SizedBox(
                          height: 10,
                        ),
                        RatingBar.builder(
                          initialRating: this.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              this.rating = rating;
                            });
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _imageWidget(),
                      ]),
                ),
              ),
            ),
            Positioned(
              child: Container(
                color: Colors.white,
                height: 100.0,
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (ratingText.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Vyplnte slovné hodnotenie.")));
                              return;
                            }

                            if (rating == 0.0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Zadajte počet hviezdičiek.")));
                              return;
                            }

                            var success = await _api.addReview(
                                widget.accommodation.id,
                                ratingText.text,
                                rating,
                                _image,
                                ratingIdToUpdate: widget.existingReview?.id);

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Recenzia bola pridaná.")));
                              Navigator.of(context).pop(true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Recenziu sa nepodarilo pridať.")));
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 60.0),
                            child: Text(
                                "${widget.existingReview != null ? 'UPRAVIŤ' : 'PRIDAŤ'} RECENZIU"),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
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
      ),
    );
  }

  Widget _imageWidget() {
    if (_image != null) {
      return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Positioned(
                  width: 24,
                  height: 24,
                  left: 90,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  ),
                )
              ],
            ),
          ));
    }

    return OutlinedButton(
      onPressed: () {
        getImage();
      },
      child: Text("Pridať fotografiu"),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
    );
  }
}
