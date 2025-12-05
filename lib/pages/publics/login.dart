import 'package:un/blocs/bloc/general_bloc/general_bloc.dart';
import 'package:un/blocs/bloc/general_bloc/general_event.dart';
import 'package:un/blocs/bloc/general_bloc/general_state.dart';
import 'package:un/blocs/bloc/login_bloc/login_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/logics/general_logic.dart';
import 'package:un/logics/logic_login.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:un/styles/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';

class LoginView extends StatelessWidget {
  final String? message;

  const LoginView({Key? key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(logicLogin: SimpleLoginLogic())),
      BlocProvider<GeneralBloc>(
        create: (_) => GeneralBloc(generalLogin: SimpleGeneral()),
      )
    ], child: LoginViewSFull(message: message));
  }
}

class LoginViewSFull extends StatefulWidget {
  final String? message;

  const LoginViewSFull({Key? key, this.message}) : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState(message: message);
}

class _LoginViewState extends State<LoginViewSFull>
    with TickerProviderStateMixin {
  final String? message;
  
  GoogleSignInAccount? _currentUser;
  late GoogleSignIn _googleSignIn;
  bool _isLoading = false;
  bool actualVersion = true;
  bool _messageShown = false;

  _LoginViewState({this.message, Key? key});

  BuildContext? contextLB;
  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize(
      serverClientId: '155837632745-ioq3cekadjsebq55kkgr94mk9gltt9aq.apps.googleusercontent.com',
    ).then((_) {
      // GoogleSignIn initialisé
    });
    
    // Écouter les événements d'authentification
    _googleSignIn.authenticationEvents.listen((event) async {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final GoogleSignInAccount account = event.user;
        try {
          final GoogleSignInAuthentication auth = await account.authentication;
          if (mounted) {
            BlocProvider.of<LoginBloc>(context)
                .add(DoLoginEvent(
                  token: auth.idToken ?? '', 
                  email: account.email ?? '',
                  response: ''
                ));
          }
        } catch (e) {
          print('Erreur auth: $e');
        }
        if (mounted) {
          setState(() {
            _currentUser = account;
          });
        }
      } else if (event is GoogleSignInAuthenticationEventSignOut) {
        if (mounted) {
          setState(() {
            _currentUser = null;
          });
        }
      }
    });
    
    BlocProvider.of<GeneralBloc>(context).add(MatchVersionEvent());
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
          body: Builder(
            builder: (scaffoldContext) {
              // Show message snackbar after first frame (only once)
              if (widget.message != null && !_messageShown) {
                _messageShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(
                      content: Text(widget.message!,
                          style: SnackBarErrorTextStyle, textAlign: TextAlign.center),
                      backgroundColor: BackgroundItemColor,
                      duration: Duration(milliseconds: 2000)));
                });
              }
              return Stack(
                children: <Widget>[
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints viewportConstraints) {
                    contextLB = context;
                    return Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration:
                        BoxDecoration(gradient: BackgroundScreenColorGradient),
                    child: BlocListener<LoginBloc, LoginBlocState>(
                      listener: (context, state) {
                        if (state is ErrorInLoginState) {
                          _googleSignIn.signOut();
                          CustomSnackbar.snackBar(
                              contextSnack: context,
                              isError: true,
                              message: state.response);
                        }
                      },
                      child: BlocBuilder<LoginBloc, LoginBlocState>(
                          builder: (context, state) {
                        return (actualVersion
                            ? _body(screenWidth, screenHeight, context)
                            : _bodyUpdate(screenWidth, screenHeight, context));
                      }),
                    ));
                  }),
                  _loading(screenHeight, screenWidth, scaffoldContext),
                  _versionCheck(screenHeight, screenWidth, scaffoldContext)
                ],
              );
            }
          )),
    );
  }

  Widget _body(
      double screenWidth, double screenHeigh, BuildContext snackContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/logo.png',
            height: 75, alignment: Alignment.center, fit: BoxFit.fill),
        SizedBox(height: 100),
        Text("Connectez-vous avec votre email",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 100),
        _btnSignGoogle(screenHeigh, screenWidth, snackContext),
        SizedBox(height: 25),
        Text("Version ${SimpleGeneral.currentVersionApp}",
            style: TextStyle(color: Colors.white, fontSize: 14))
      ],
    );
  }

  Widget _bodyUpdate(
      double screenWidth, double screenHeigh, BuildContext snackContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/logo.png',
            height: 75, alignment: Alignment.center, fit: BoxFit.fill),
        SizedBox(height: 100),
        Text("Vous devez mettre à jour l'application",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(height: 100),
        _warningVersion(screenHeigh, screenWidth, snackContext),
        SizedBox(height: 25)
      ],
    );
  }

  Widget _warningVersion(screenHeigh, screenWidth, snackContext) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeigh * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: MaterialButton(
        onPressed: () async {
          try {
            final InAppReview inAppReview = InAppReview.instance;
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          } catch (error) {
            CustomSnackbar.snackBar(
                contextSnack: snackContext,
                isError: true,
                message: "Veuillez accéder manuellement au PlayStore");
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/google.png',
                height: 35, alignment: Alignment.bottomCenter),
            Text("    Mettre à jour",
                style: TextStyle(color: PrimaryThemeColor, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _btnSignGoogle(
      double screenWidth, double screenHeigh, BuildContext snackContext) {
    return Container(
      width: screenHeigh * 0.75,
      height: screenWidth * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: MaterialButton(
        onPressed: () async {
          try {
            setState(() {
              _isLoading = true;
            });
            final result = await _googleSignIn.authenticate();
            print('✅ Auth réussie: ${result.email}');
          } catch (error) {
            print('❌ Erreur Google Sign-In: $error');
            CustomSnackbar.snackBar(
                contextSnack: snackContext,
                isError: true,
                message: "Erreur: $error");
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/google.png',
                height: 35, alignment: Alignment.bottomCenter),
            Text("    Se connecter avec Google",
                style: TextStyle(color: PrimaryThemeColor, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _loading(double screenHeight, double screenWidth, snackContext) {
    return BlocListener<LoginBloc, LoginBlocState>(
      listener: (context, state) {
        if (state is LoadingLoginState) {
          _isLoading = true;
        } else {
          _isLoading = false;
        }
        if (state is DoLoginState) {
          Map obj = {'username': _currentUser?.displayName ?? ''};
          Navigator.pushNamed(context, HomeViewRoute, arguments: obj);
        }
        if (state is ErrorInLoginState) {
          CustomSnackbar.snackBar(
              contextSnack: snackContext,
              isError: true,
              message: state.response);
        }
        if (state is TokenErrorInLoginState) {
          CustomSnackbar.snackBar(
              contextSnack: snackContext,
              isError: true,
              message: "Erreur d'authentification");
          _googleSignIn.signOut();
        }
      },
      child: BlocBuilder<LoginBloc, LoginBlocState>(builder: (context, state) {
        return (_isLoading)
            ? CustomLoading(
                screenHeight: screenHeight, screenWidth: screenWidth)
            : Container();
      }),
    );
  }

  Widget _versionCheck(double screenHeight, double screenWidth, snackContext) {
    return BlocListener<GeneralBloc, GeneralState>(
      listener: (context, state) {
        if (state is VersionGettedState) {
          _isLoading = false;
          if (state.version["versionOk"]) {
            setState(() {
              actualVersion = true;
            });
          } else if (!state.version["versionOk"]) {
            setState(() {
              actualVersion = false;
            });
          }
          return;
        }
        if (state is VersionErrorState) {
          _isLoading = false;
          setState(() {
            actualVersion = true;
          });
        }
      },
      child: BlocBuilder<LoginBloc, LoginBlocState>(builder: (context, state) {
        return (_isLoading)
            ? CustomLoading(
                screenHeight: screenHeight, screenWidth: screenWidth)
            : Container();
      }),
    );
  }
}
