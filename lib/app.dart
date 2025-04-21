import 'package:flutter/material.dart';
import 'package:time_to_pray_app/main.dart';
import 'package:time_to_pray_app/pages/splash_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isInitStarted; //1

  @override
  void initState() {
    super.initState();
    isInitStarted = prefs.getBool('isInitStarted') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SplashPage();
    // return isInitStarted
    //     ? InitStartPage(
    //         onStart: () {
    //           setState(() {
    //             isInitStarted = false;
    //           });
    //           prefs.setBool('isInitStarted', isInitStarted);
    //         },
    //       )
    //     : const SplashPage();
  }
}
