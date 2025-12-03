import 'package:flutter/material.dart';
import 'package:un/styles/style.dart';

import 'routes/router.dart';
import 'routes/routing_constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KasNet',
      theme: ThemeData(
          fontFamily: 'Helvetica',
          cardColor: PrimaryThemeColor,
          primaryColor: PrimaryThemeColor),
      onGenerateRoute: generateRoute, // -> Invoke method generateRoute
      initialRoute: LoginViewRoute,
    );
  }
}
