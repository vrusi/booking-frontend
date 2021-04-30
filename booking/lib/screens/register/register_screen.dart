import 'package:booking/api/api_client.dart';
import 'package:booking/screens/login/login_screen.dart' as Login;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterScreen extends StatefulWidget {
  static const ROUTE = "/register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Api _api = GetIt.instance.get<Api>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BOOKING'),
        ),
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Login.Form(
                    titleText: "Registrácia",
                    buttonText: "Registrovať",
                    alternativeButtonText: "Už máte účet?",
                    onButtonClicked: (String email, String password) async {
                      final loggedIn = await _api.register(email, password);

                      if (loggedIn) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Boli ste úspešne zaregistrovaní.")));
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Registrácia sa nepodarila.")));
                      }
                    },
                    onAlternativeButtonClicked: () {
                      Navigator.of(context).popAndPushNamed(Login.LoginScreen.ROUTE);
                    })
              ],
            )));
  }
}
