import 'package:un/blocs/bloc/general_bloc/bloc.dart';
import 'package:un/blocs/bloc/general_bloc/general_bloc.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/common/menu_drawer.dart';
import 'package:un/logics/general_logic.dart';
import 'package:un/logics/logic.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:un/styles/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeView extends StatelessWidget {
  final String username;

  const HomeView({Key? key, required this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<GeneralBloc>(
          create: (_) => GeneralBloc(generalLogin: SimpleGeneral()))
    ], child: HomeViewSFull(username: username));
  }
}

class HomeViewSFull extends StatefulWidget {
  final String username;

  const HomeViewSFull({Key? key, required this.username}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState(username: username);
}

class _HomeViewState extends State<HomeViewSFull> {
  final String username;
  _HomeViewState({required this.username});

  var _scaffoldKey;
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    // TODO: Configure scopes for GoogleSignIn 7.x if needed
    // BlocProvider.of<GeneralBloc>(context).add(MatchVersionEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.vertical > 0;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Kasnet Ventas"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.input),
                onPressed: () async {
                  final action = await CustomDialogConfirm.yesAbortDialog(
                      context, "", "¿Desea cerrar sesión?");
                  if (action == DialogAction.yes) {
                    WService.clearPref();
                    _googleSignIn.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginViewRoute, (Route<dynamic> route) => false);
                  }
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              color: TertiaryThemeColor,
              child: _body(screenHeight, screenWidth),
            ),
            Logo(isKeyboard: isKeyboard),
            MultiBlocListener(
              listeners: [
                BlocListener<GeneralBloc, GeneralState>(
                    listener: (context, state) {
                  if (state is VersionGettedState) {
                    if (state.version["versionOk"]) {
                      CustomSnackbar.snackBar(
                          contextSnack: context,
                          isError: false,
                          message: "Nueva versión disponible. Ver más...",
                          isInteractive: true,
                          time: 10000);
                    }
                    return;
                  }
                }),
              ],
              child: Container(),
            )
          ],
        ),
        drawer: MenuDrawer(nameUser: username),
      ),
    );
  }

  Widget _body(double screenHeight, double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: screenHeight * 0.10,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text("Bienvenida(o): " + username,
                textAlign: TextAlign.center, style: BtnLightTextStyle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: screenWidth * 0.90,
            height: screenHeight * 0.10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: SecondaryThemeColor,
            ),
            child: MaterialButton(
              onPressed: () {
                WService.clearPref();
                Navigator.pushNamed(context, VisitAgentRoute);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: SvgPicture.asset('assets/images/home/agent.svg',
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.07,
                        alignment: Alignment.center,
                        color: PrimaryThemeColor),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.125),
                    child: Text("Visita Agente",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: PrimaryThemeColor,
                            fontSize: screenWidth * 0.055)),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
