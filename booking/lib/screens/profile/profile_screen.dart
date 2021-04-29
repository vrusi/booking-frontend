import 'package:booking/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatelessWidget {
  static const ROUTE = "/profile";
  var api = GetIt.instance.get<Api>();

  @override
  Widget build(BuildContext context) {
    var user = api.getUser();

    return Scaffold(
        appBar: AppBar(
          title: Text('PROFIL'),
        ),
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ste prihlaseny ako",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(user?.email ?? ""),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await api.setUser(null);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Boli ste odhlaseny")));
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80.0, vertical: 14.0),
                    child: Text("Odhlasit sa"),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  )),
            ],
          ),
        )));
  }
}
