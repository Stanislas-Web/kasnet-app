import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final bool isKeyboard;

  const Logo({Key? key, required this.isKeyboard}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Opacity(
                opacity: !isKeyboard ? 1.0 : 0.0,
                child:
                    Image.asset('assets/images/logo_solo.png', width: 135.0))));
  }
}
