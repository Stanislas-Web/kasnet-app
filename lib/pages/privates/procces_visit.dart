import 'package:un/blocs/bloc/process_bloc/process_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_process.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/models/process.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProccesVisitView extends StatelessWidget {
  final bool isDown;
  final Visit visitReceived;

  const ProccesVisitView({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ProcessBloc>(
          create: (_) => ProcessBloc(processLogic: SimpleProcess())),
      BlocProvider<VisitBloc>(
          create: (_) => VisitBloc(visitLogic: SimpleVisit()))
    ], child: ProccesVisitSFull(isDown: isDown, visitReceived: visitReceived));
  }
}

class ProccesVisitSFull extends StatefulWidget {
  final bool isDown;
  final Visit visitReceived;

  const ProccesVisitSFull({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);
  @override
  _ProccesVisitState createState() =>
      _ProccesVisitState(visitReceived: visitReceived);
}

class _ProccesVisitState extends State<ProccesVisitSFull> {
  late String options;
  final Visit visitReceived;
  // AutoCompleteTextField removed - deprecated package
  // GlobalKey<AutoCompleteTextFieldState<dynamic>> key = GlobalKey();
  String _stateText = "Sélectionnez l'état";
  bool _isLoading = false;

  BuildContext? contextLB;  // Rendre nullable

  List<Process> _proccessList = [];
  
  // Map de traduction espagnol -> français
  final Map<String, String> _translations = {
    "Instalacion de Equipo": "Installation d'équipement",
    "Capacitacion": "Formation",
    "Mantenimiento de Equipos y Suministro": "Maintenance d'équipements et fournitures",
    "Seguimiento Comercial": "Suivi commercial",
    "Recojo de Equipo": "Récupération d'équipement",
    "Encargo Varios": "Tâches diverses",
  };

  late GoogleSignIn _googleSignIn;

  var _scaffoldKey;

  _ProccesVisitState({required this.visitReceived});

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    BlocProvider.of<ProcessBloc>(context).add(GetProcessesEvent());
  }

  Future<Null> getSharedPrefs() async {
    if (WService.visitPrefTipo.isNotEmpty) {
      setState(() {
        for (var j = 0; j < WService.visitPrefTipo.length; j++) {
          Map pro = WService.visitPrefTipo[j];
          for (var i = 0; i < _proccessList.length; i++) {
            if (_proccessList[i].descripcion == pro['descripcion']) {
              _proccessList[i].valor = true;
            }
          }
        }
      });
    }
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: PrimaryThemeColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Visite d'agent", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.input),
              onPressed: () async {
                final action = await CustomDialogConfirm.yesAbortDialog(
                    context, "", "Voulez-vous vous déconnecter ?");
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
          LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            contextLB = context;
            return Container(
              width: screenWidth,
              height: screenHeight,
              color: TertiaryThemeColor,
              child: _body(screenHeight, screenWidth, context),
            );
          }),
          Logo(isKeyboard: isKeyboard),
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return _loading(screenHeight, screenWidth, context);
          }),
          _verifyUpdateVisit(),
        ],
      ),
    );
  }

  Widget _body(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 25),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.575,
            ),
            child: Container(
                width: screenWidth - 50,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 5, color: Colors.white),
                    borderRadius: BorderRadius.circular(5)),
                child: SingleChildScrollView(
                    child: _containerListCheck(
                        screenHeight, screenWidth, contextSnack))),
          ),
          SizedBox(height: screenHeight * 0.15),
          _btnNextStep(screenWidth, contextSnack),
        ],
      ),
    );
  }

  Widget _containerListCheck(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text("Choisissez la/les activité(s) à réaliser :",
                style: LabelBlueBoldInputTextStyle, textAlign: TextAlign.start),
          ),
          BlocListener<ProcessBloc, ProcessState>(
            listener: (context, state) {
              if (state is GetProcessesState) {
                print("📋 Processus reçus du backend:");
                for (var item in state.process) {
                  print("  - ${item.descripcion}");
                }
                
                if (widget.isDown) {
                  for (var item in state.process) {
                    item.valor = (item.valor == null) ? false : item.valor;
                    if (item.descripcion == "Recojo de Equipo" ||
                        item.descripcion == "Encargo Varios") {
                      _proccessList.add(item);
                    }
                  }
                } else {
                  for (var item in state.process) {
                    item.valor = (item.valor == null) ? false : item.valor;
                    if (item.descripcion == "Instalacion de Equipo" ||
                        item.descripcion == "Capacitacion" ||
                        item.descripcion ==
                            "Mantenimiento de Equipos y Suministro" ||
                        item.descripcion == "Seguimiento Comercial") {
                      _proccessList.add(item);
                    }
                  }
                }
              }
              if (state is TokenErrorInProcessState) {
                WService.clearPref();
                Map obj = {'message': 'Token invalide. Veuillez vous reconnecter'};
                Navigator.pushNamed(
                  context,
                  LoginViewRoute,
                  arguments: obj,
                );
              }
              if (state is ErrorInProcessState) {
                CustomSnackbar.snackBar(
                    contextSnack: contextSnack,
                    isError: true,
                    message: state.response);
              }
              getSharedPrefs();
            },
            child: BlocBuilder<ProcessBloc, ProcessState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _proccessList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: PrimaryThemeColor),
                                  child: Checkbox(
                                      value: _proccessList[index].valor ?? false,
                                      checkColor: SecondaryThemeColor,
                                      activeColor: PrimaryThemeColor,
                                      onChanged: (val) {
                                        setState(() {
                                          _proccessList[index].valor = val;
                                        });
                                      }),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _proccessList[index].valor =
                                            !(_proccessList[index].valor ?? false);
                                      });
                                    },
                                    child: Container(
                                        width: screenWidth * 0.6,
                                        child: Text(
                                            _translations[_proccessList[index].descripcion] ?? 
                                            _proccessList[index].descripcion ?? '',
                                            style:
                                                LabelSMBlueNormalInputTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true)))
                              ],
                            ),
                          ],
                        );
                      }),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _loading(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<ProcessBloc, ProcessState>(
      listener: (context, state) {
        if (state is TokenErrorInProcessState) {
          WService.clearPref();
          Map obj = {'message': 'Token invalide. Veuillez vous reconnecter'};
          Navigator.pushNamed(
            context,
            LoginViewRoute,
            arguments: obj,
          );
        }
        if (state is ErrorInProcessState) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: state.response);
        }

        if (state is LoadingInProcessState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: BlocBuilder<ProcessBloc, ProcessState>(builder: (context, state) {
        return (_isLoading)
            ? CustomLoading(
                screenHeight: screenHeight, screenWidth: screenWidth)
            : Container();
      }),
    );
  }

  Widget _verifyUpdateVisit() {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        if (state is LoadingVisitState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is UpdateVisitState) {
          if (_stateText == "Fermé") {
            Map obj = {'visit': state.visit, 'stateStore': widget.isDown};
            Navigator.pushNamed(context, LocationAgentViewRoute,
                arguments: obj);
          } else if (widget.isDown) {
            Map obj = {'visit': state.visit, 'stateStore': widget.isDown};
            Navigator.pushNamed(context, LocationAgentViewRoute,
                arguments: obj);
          } else {
            Map obj = {'visit': state.visit, 'stateStore': widget.isDown};
            Navigator.pushNamed(context, InformationAgentViewRoute,
                arguments: obj);
          }
        }
        if (state is TokenErrorInVisitState) {
          WService.clearPref();
          Map obj = {'message': 'Token invalide. Veuillez vous reconnecter'};
          Navigator.pushNamed(
            context,
            LoginViewRoute,
            arguments: obj,
          );
        }
        if (state is ErrorInVisitState) {
          SnackBar(
              content: Text(state.response,
                  style: SnackBarErrorTextStyle, textAlign: TextAlign.center));
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }

  Widget _btnNextStep(double screenWidth, BuildContext contextSnack) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: SecondaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Container(
        width: screenWidth * 0.6,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text((!widget.isDown) ? "Interroger" : "Localiser le magasin",
                style: SemiTitleBlueTextStyle),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () {
        _validateCheckProcces(contextSnack);
      },
    );
  }

  void _validateCheckProcces(contextSnack) {
    List<Process> _proccessListSelected = [];
    Visit visit = Visit();
    visit = visitReceived;
    visit.tipoGestion?.clear();
    for (var i = 0; i < _proccessList.length; i++) {
      if (_proccessList[i].valor ?? false) {
        Map obj = {
          "accion": _proccessList[i].accion,
          "activo": _proccessList[i].activo,
          "codigo": _proccessList[i].codigo,
          "descripcion": _proccessList[i].descripcion,
          "flujoDePantallas": _proccessList[i].flujoDePantallas
        };
        _proccessListSelected.add(_proccessList[i]);
        visit.tipoGestion?.add(obj);
      }
      if (i >= _proccessList.length - 1) {
        if (_proccessListSelected.length <= 0) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Veuillez sélectionner au moins une gestion");
          break;
        } else {
          visit.estado = 2;
          BlocProvider.of<VisitBloc>(context)
              .add(UpdateVisitEvent(visit: visit));
          break;
        }
      }
    }
  }
}
