import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final String info;
  const LoginView({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginViewSFull(info: this.info);
  }
}

class LoginViewSFull extends StatefulWidget {
  final String info;

  const LoginViewSFull({Key? key, required this.info}) : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginViewSFull>
    with TickerProviderStateMixin {
  _LoginViewState({Key? key});

  var _scaffoldKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration:
                    BoxDecoration(gradient: BackgroundScreenColorGradient),
                child: _logo(),
              ),
            ],
          )),
    );
  }

  Widget _logo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/logo.png',
            height: 75, alignment: Alignment.center, fit: BoxFit.fill)
      ],
    );
  }
}
