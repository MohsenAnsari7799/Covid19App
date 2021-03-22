import 'package:covid19/screens/show_countries.dart';
import "package:flutter/material.dart";

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _handleSplash();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/flags/covid19.png"),
            Text(
              "کووید19",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontFamily: "DanaBold",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSplash() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ShowCountries();
    }));
  }
}
