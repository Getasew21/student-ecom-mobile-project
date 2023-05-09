import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("lib/images/Wollo-University-logo.png"),
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
