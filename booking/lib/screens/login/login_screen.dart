import 'package:booking/api/api_client.dart';
import 'package:booking/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  static const ROUTE = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Api _api = GetIt.instance.get<Api>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
            Form(
                titleText: "Prihlásenie",
                buttonText: "Prihlásiť",
                alternativeButtonText: "Ešte nemáte účet?",
                onButtonClicked: (String email, String password) async {
                  final loggedIn = await _api.login(email, password);

                  if (loggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Boli ste úspešne prihlásení.")));
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Prihlásenie sa nepodarilo.")));
                  }
                },
                onAlternativeButtonClicked: () {
                  Navigator.of(context).popAndPushNamed(RegisterScreen.ROUTE);
                })
          ],
        )));
  }
}

class Form extends StatefulWidget {
  final String buttonText;
  final String titleText;
  final String alternativeButtonText;
  final Function onButtonClicked;
  final Function onAlternativeButtonClicked;

  const Form(
      {Key? key,
      required this.buttonText,
      required this.titleText,
      required this.onButtonClicked,
      required this.alternativeButtonText,
      required this.onAlternativeButtonClicked})
      : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.titleText,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: TextField(
            autocorrect: false,
            controller: _email,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'vas@email.sk'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
          child: TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Heslo',
                hintText: 'neodhadnutelne'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ElevatedButton(
              onPressed: () {
                widget.onButtonClicked(_email.text, _password.text);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 80.0, vertical: 14.0),
                child: Text(widget.buttonText),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: OutlinedButton(
            onPressed: () {
              widget.onAlternativeButtonClicked();
            },
            child: Text(widget.alternativeButtonText),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
            ),
          ),
        )
      ],
    );
  }
}
