import 'package:un/logics/logic.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dialogs/custom_dialog_confirm.dart';

enum options {
  home,
  informationPersonal,
  contracts,
  authorizatioLetters,
  changePassword,
  logout
}

class MenuDrawer extends StatelessWidget {
  final String nameUser;
  final int? timeVisit;

  const MenuDrawer({Key? key, this.timeVisit, required this.nameUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuDrawerSFull(nameUser: nameUser);
  }
}

class MenuDrawerSFull extends StatefulWidget {
  final String nameUser;
  final int? timeVisit;

  MenuDrawerSFull({Key? key, this.timeVisit, required this.nameUser}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState(timeVisit, nameUser);
}

class _MenuDrawerState extends State<MenuDrawerSFull> {
  final String nameUser;
  final int? timeVisit;

  List<Map> options = [
    {'home': 'Accueil'},
    {'informationPersonal': 'Informations personnelles'},
    {'contracts': 'Contrats'},
    {'authorizatioLetters': 'Lettres d\'autorisation'},
    {'changePassword': 'Changer le mot de passe'},
    {'logout': 'Déconnexion'}
  ];
  bool expandedItem = false;
  bool expandedItemData = false;
  String nameAgent = "";

  GoogleSignIn? _googleSignIn;

  _MenuDrawerState(this.timeVisit, this.nameUser);

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    _googleSignIn = GoogleSignIn.instance;
    await _googleSignIn!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return _menuDrawer(context);
  }

  Widget _menuDrawer(context) {
    return Drawer(
      child: Stack(children: <Widget>[
        Container(
          color: SecondaryThemeColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: PrimaryThemeColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/logo.png',
                            height: 55, alignment: Alignment.center),
                      ],
                    ),
                    Text(
                      widget.nameUser,
                      style: BtnLightTextStyle,
                    )
                  ],
                ),
              ),
              // SizedBox(height: 10.0,),
              _menuDrawerItem(
                  context: context,
                  height: 50,
                  image: "assets/images/home/start.svg",
                  text: "Accueil",
                  view: ""),
              _customDivider(),
              // SizedBox(height: 10.0,),
              _menuDrawerItem(
                  context: context,
                  height: 55,
                  image: "assets/images/home/agent.svg",
                  text: "Visite d'agent",
                  view: VisitAgentRoute),
              // SizedBox(height: 10.0,),
              _customDivider(),
              _menuDrawerItem(
                  context: context,
                  height: 55,
                  image: "assets/images/home/close.svg",
                  text: "Déconnexion",
                  view: LoginViewRoute),
              // SizedBox(height: 10.0,),
              _customDivider(),
            ],
          ),
        ),
        _footerDrawer(),
      ]),
    );
  }

  Widget _menuDrawerItem(
      {required BuildContext context,
      double height = 0.0,
      required String text,
      required String image,
      String view = HomeViewRoute}) {
    return Container(
      height: height,
      alignment: Alignment.center,
      color: SecondaryThemeColor,
      child: ListTile(
        leading: SvgPicture.asset(image,
            color: PrimaryThemeColor,
            height: 35,
            width: 35,
            alignment: Alignment.center),
        title: Text(text, style: TextStyle(color: PrimaryThemeColor)),
        onTap: () async {
          if (view == "") {
            Navigator.pop(context);
          } else if (view == LoginViewRoute) {
            final action = await CustomDialogConfirm.yesAbortDialog(
                context, "", "Voulez-vous vous déconnecter ?");
            if (action == DialogAction.yes) {
              WService.clearPref();
              _googleSignIn?.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginViewRoute, (Route<dynamic> route) => false);
            }
          } else {
            Navigator.pushNamed(context, view);
          }
        },
      ),
    );
  }

  Widget _customDivider() {
    return Divider(
        color: Color.fromRGBO(130, 130, 130, 1), thickness: .75, height: 0.0);
  }

  Widget _footerDrawer() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Version 1.1',
            style: TextStyle(color: Color.fromRGBO(32, 72, 142, 0.5))),
      ),
    );
  }
}
