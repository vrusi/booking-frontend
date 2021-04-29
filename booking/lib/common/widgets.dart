import 'package:booking/api/api_client.dart';
import 'package:booking/screens/login/login_screen.dart';
import 'package:booking/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AccountButton extends StatelessWidget {
  final Function? onPressed;

  const AccountButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {
          if (this.onPressed != null) {
            this.onPressed?.call();
          } else {
            final api = GetIt.instance.get<Api>();
            if(api.getUser() == null){
              Navigator.of(context).pushNamed(LoginScreen.ROUTE);
            } else {
              Navigator.of(context).pushNamed(ProfileScreen.ROUTE);
            }
          }
        });
  }
}

class Common {
  static Text title(Accommodation accommodation,
          {FontWeight fontWeight = FontWeight.normal}) =>
      Text(
        accommodation.title,
        style: TextStyle(fontWeight: fontWeight),
      );

  static Widget rating(BuildContext context, Accommodation accommodation) {
    var ratingText = accommodation.rating != null
        ? "${accommodation.rating!.toStringAsFixed(1)} z 5"
        : "-";
    var ratingCountText = accommodation.ratingCount == 0
        ? ""
        : " (${accommodation.ratingCount} hodnoteni)";

    return Row(
      children: [
        Icon(
          Icons.star_rate,
          size: 16.0,
          color: Colors.amber,
        ),
        RichText(
          text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              children: <TextSpan>[
                TextSpan(
                    text: ratingText,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ratingCountText),
              ]),
        )
      ],
    );
  }

  static Widget pricing(BuildContext context, Accommodation accommodation) {
    return RichText(
      text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
                text: '${accommodation.price.toStringAsFixed(0)} €',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' / noc'),
          ]),
    );
  }
}
