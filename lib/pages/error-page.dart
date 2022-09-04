import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ErrorPage extends StatelessWidget {
  String? errorStr;
  ErrorPage({this.errorStr});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$errorStr', style: TextStyle(fontSize: 20, color: Colors.red),),

              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ));
                },
                child: const Text('Go to home'),
              ),
            ],
          ),
        ),
      );

  }
}