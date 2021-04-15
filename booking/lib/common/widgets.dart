import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final Function? onPressed;

  const AccountButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.account_circle),
        onPressed: () {
          this.onPressed?.call();
        });
  }
}
