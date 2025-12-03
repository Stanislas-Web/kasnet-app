import 'package:un/blocs/bloc/agent_bloc/agent_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_scrollbar.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_agent.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/logics/string_capital.dart';
import 'package:un/models/days.dart';
import 'package:un/models/find_agent.dart';
import 'package:un/models/turnes.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InformationAgentSecondaryView extends StatelessWidget {
  final String codeStore;
  final Visit visitReceived;
  final bool isDown;

  const InformationAgentSecondaryView(
      {Key? key, required this.codeStore, required this.visitReceived, required this.isDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VisitBloc>(
              create: (_) => VisitBloc(visitLogic: SimpleVisit())),
          BlocProvider<AgentBloc>(
              create: (_) => AgentBloc(agentLogic: SimpleAgent()))
        ],
        child: InformationAgentSecondarySFull(
            codeStore: codeStore,
            visitReceived: visitReceived,
            isDown: isDown));
  }
}

class InformationAgentSecondarySFull extends StatefulWidget {
  final String codeStore;
  final Visit visitReceived;
  final bool isDown;

  const InformationAgentSecondarySFull(
      {Key? key, required this.codeStore, required this.visitReceived, required this.isDown})
      : super(key: key);
  @override
  _InformationAgentSecondaryState createState() =>
      _InformationAgentSecondaryState(visitReceived: visitReceived);
}

class _InformationAgentSecondaryState
    extends State<InformationAgentSecondarySFull> {
  late FindAgentResponse data;
  final Visit visitReceived;

  String address = "";
  String contact = "";
  String store = "";

  // AutoCompleteTextField removed - deprecated package
  // GlobalKey<AutoCompleteTextFieldState<dynamic>> key = GlobalKey();
  bool _isLoading = false;

  List<Day> _days = [];
  List<Turne> _turnes = [];
  Day lunes = Day(description: "Lunes", value: false);
  Day martes = Day(description: "Martes", value: false);
  Day miercoles = Day(description: "Miercoles", value: false);
  Day jueves = Day(description: "Jueves", value: false);
  Day viernes = Day(description: "Viernes", value: false);
  Turne turneA = Turne(description: "Mañana", value: false);
  Turne turneB = Turne(description: "Tarde", value: false);
  late BuildContext contextLB;
  late GoogleSignIn _googleSignIn;
  var _scaffoldKey;

  _InformationAgentSecondaryState({required this.visitReceived});

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    _days.add(lunes);
    _days.add(martes);
    _days.add(miercoles);
    _days.add(jueves);
    _days.add(viernes);
    _turnes.add(turneA);
    _turnes.add(turneB);
    BlocProvider.of<VisitBloc>(context).add(GetLocationEvent(
        codeStore: visitReceived.codigo ?? '', state: visitReceived.estado ?? 0));
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
      onWillPop: () async => saveData(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: PrimaryThemeColor,
          title: Text("Datos del agente"),
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
            _loading(screenHeight, screenWidth, contextLB),
            _loadingAgent(screenHeight, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _body(double screenHeight, double screenWidth, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.only(right: 10, left: 10, bottom: 15),
              decoration: BoxDecoration(
                  color: DisabledThemeColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  _commerce(),
                  _contact(),
                  _adress(),
                ],
              ),
            ),
          ),
          ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: screenHeight * 0.4,
                minWidth: screenWidth * 0.85,
                maxHeight: screenHeight * 0.45,
                maxWidth: screenWidth * 0.90,
              ),
              child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 5, color: Colors.white),
                      borderRadius: BorderRadius.circular(5)),
                  child: SingleChildScrollViewWithScrollbar(
                      scrollbarColor: PrimaryThemeColor,
                      child: SingleChildScrollView(
                          child: _containerListCheck(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth))))),
          Padding(padding: EdgeInsets.only(top: 15)),
          _btnNextStep(screenWidth, context),
          SizedBox(height: 0)
        ],
      ),
    );
  }

  Widget _commerce() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Comercio: ", style: LabelBlueNormalInputTextStyle),
          Flexible(
              child: Text(capitalizeAll(store.toLowerCase()),
                  style: new TextStyle(
                      color: PrimaryThemeColor,
                      fontSize: 15.0,
                      fontFamily: DefaultFontFamily),
                  textAlign: TextAlign.end))
        ],
      ),
    );
  }

  Widget _contact() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Contacto: ", style: LabelBlueNormalInputTextStyle),
          Flexible(
              child: Text(capitalizeAll(contact.toLowerCase()),
                  style: new TextStyle(
                      color: PrimaryThemeColor,
                      fontSize: 15.0,
                      fontFamily: DefaultFontFamily),
                  textAlign: TextAlign.start))
        ],
      ),
    );
  }

  Widget _adress() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Dirección: ", style: LabelBlueNormalInputTextStyle),
          Flexible(
              child: Text(capitalizeAll(address.toLowerCase()),
                  style: new TextStyle(
                      color: PrimaryThemeColor,
                      fontSize: 15.0,
                      fontFamily: DefaultFontFamily),
                  textAlign: TextAlign.start))
        ],
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
            Text("Hacer encuesta", style: SemiTitleBlueTextStyle),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () {
        _validateChecks(contextSnack);
      },
    );
  }

  Widget _containerListCheck({required double screenWidth, required double screenHeight}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15, right: 30, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text("Horario Para Contacto Telefónico*",
                style: LabelBlueBoldInputTextStyle, textAlign: TextAlign.start),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BlocListener<AgentBloc, AgentState>(
                listener: (context, state) {
                  if (state is GetAgentState) {}
                },
                child: BlocBuilder<AgentBloc, AgentState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Día",
                                style: LabelBlueBoldInputTextStyle)),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            height: screenHeight * 0.4,
                            width: screenWidth * 0.35,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: _days.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    PrimaryThemeColor),
                                            child: Checkbox(
                                                value: _days[index].value ?? false,
                                                checkColor: SecondaryThemeColor,
                                                activeColor: PrimaryThemeColor,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _days[index].value = val;
                                                  });
                                                }),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _days[index].value =
                                                      !(_days[index].value ?? false);
                                                });
                                              },
                                              child: Text(
                                                  _days[index].description ?? '',
                                                  style:
                                                      LabelSMBlueNormalInputTextStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true))
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              BlocListener<AgentBloc, AgentState>(
                listener: (context, state) {
                  if (state is GetAgentState) {}
                },
                child: BlocBuilder<AgentBloc, AgentState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("Turno",
                                style: LabelBlueBoldInputTextStyle)),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            height: screenHeight * 0.4,
                            width: screenWidth * 0.35,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: _turnes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    PrimaryThemeColor),
                                            child: Checkbox(
                                                value: _turnes[index].value ?? false,
                                                checkColor: SecondaryThemeColor,
                                                activeColor: PrimaryThemeColor,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _turnes[index].value = val;
                                                  });
                                                }),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _turnes[index].value =
                                                      !(_turnes[index].value ?? false);
                                                });
                                              },
                                              child: Text(
                                                  _turnes[index].description ?? '',
                                                  style:
                                                      LabelSMBlueNormalInputTextStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true))
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _loading(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        (state is LoadingVisitState) ? _isLoading = true : _isLoading = false;
        if (state is UpdateVisitState) {
          if (WService.stateAgent == 2) {
            data.diasDisponibles = visitReceived.diasDisponibles?.cast<String>();
            data.horasDisponibles = visitReceived.horasDisponibles?.cast<String>();
            visitReceived.correoElectronico = data.correoElectronico;
            visitReceived.correoElectronico2 = data.correoElectronico2;
            BlocProvider.of<AgentBloc>(context)
                .add(UpdateAgentEvent(visit: visitReceived, agent: data));
          } else {
            Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
            Navigator.pushNamed(context, QuestionOneViewRoute, arguments: obj);
          }
        }

        if (state is GetLocationState) {
          setState(() {
            if (state.agentData != null) {
              data = state.agentData;
              address = state.agentData.direccion ?? '';
              contact = state.agentData.nombreTitular ?? '';
              store = state.agentData.nombreComercio ?? '';

              if (state.agentData.diasDisponibles != null &&
                  (state.agentData.diasDisponibles?.isNotEmpty ?? false) &&
                  state.agentData.horasDisponibles != null &&
                  (state.agentData.horasDisponibles?.isNotEmpty ?? false)) {
                for (var i = 0; i < _days.length; i++) {
                  for (var j = 0;
                      j < (state.agentData.diasDisponibles?.length ?? 0);
                      j++) {
                    if (_days[i].description ==
                        state.agentData.diasDisponibles?[j]) {
                      _days[i].value = true;
                    }
                  }
                }

                for (var i = 0; i < _turnes.length; i++) {
                  for (var j = 0;
                      j < (state.agentData.horasDisponibles?.length ?? 0);
                      j++) {
                    if (_turnes[i].description ==
                        state.agentData.horasDisponibles?[j]) {
                      _turnes[i].value = true;
                    }
                  }
                }
              }
            }
          });
          getSharedPrefs();
        }

        if (state is TokenErrorInVisitState) {
          WService.clearPref();
          Map obj = {'message': 'Token inválido. Inicie sesión'};
          Navigator.pushNamed(
            context,
            LoginViewRoute,
            arguments: obj,
          );
        }
        if (state is ErrorInVisitState) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: state.response);
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return (_isLoading)
              ? Center(
                  child: CustomLoading(
                      screenHeight: screenHeight, screenWidth: screenWidth),
                )
              : Container();
        },
      ),
    );
  }

  Widget _loadingAgent(double screenHeight, double screenWidth) {
    return BlocListener<AgentBloc, AgentState>(
      listener: (context, state) {
        (state is LoadingGetAgentState)
            ? _isLoading = true
            : _isLoading = false;
        if (state is UpdateAgentState) {
          Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
          Navigator.pushNamed(context, QuestionOneViewRoute, arguments: obj);
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return (_isLoading)
              ? Center(
                  child: CustomLoading(
                      screenHeight: screenHeight, screenWidth: screenWidth),
                )
              : Container();
        },
      ),
    );
  }

  Future<Null> getSharedPrefs() async {
    if (WService.diasDisponibles != null) {
      setState(() {
        for (var i = 0; i <= _days.length - 1; i++) {
          for (var j = 0; j <= (WService.diasDisponibles?.length ?? 0) - 1; j++) {
            if ((_days[i].description ?? '').toLowerCase() ==
                WService.diasDisponibles?[j].toString().toLowerCase()) {
              _days[i].value = true;
              break;
            } else {
              _days[i].value = false;
            }
          }
        }
      });
    } else {
      setState(() {
        for (var j = 0; j <= _days.length - 1; j++) {
          _days[j].value = false;
        }
      });
    }

    if (WService.horasDisponibles != null) {
      setState(() {
        for (var i = 0; i <= _turnes.length - 1; i++) {
          for (var j = 0; j <= (WService.horasDisponibles?.length ?? 0) - 1; j++) {
            if ((_turnes[i].description ?? '').toLowerCase() ==
                WService.horasDisponibles?[j].toString().toLowerCase()) {
              _turnes[i].value = true;
              break;
            } else {
              _turnes[i].value = false;
            }
          }
        }
      });
    } else {
      setState(() {
        for (var j = 0; j <= _turnes.length - 1; j++) {
          _turnes[j].value = false;
        }
      });
    }
  }

  void _validateChecks(contextSnack) {
    List<String> _daysListSelected = [];
    List<String> _turnesListSelected = [];
    for (var i = 0; i < _days.length; i++) {
      if (_days[i].value ?? false) {
        _daysListSelected.add(_days[i].description ?? '');
      }
      if (i >= _days.length - 1) {
        if (_daysListSelected.length <= 0) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Seleccione al menos un día");
          break;
        } else {
          for (var i = 0; i < _turnes.length; i++) {
            if (_turnes[i].value ?? false) {
              _turnesListSelected.add(_turnes[i].description ?? '');
            }
            if (i >= _turnes.length - 1) {
              if (_turnesListSelected.length <= 0) {
                CustomSnackbar.snackBar(
                    contextSnack: contextSnack,
                    isError: true,
                    message: "Seleccione al menos un turno");
                break;
              } else {
                visitReceived.diasDisponibles = _daysListSelected;
                visitReceived.horasDisponibles = _turnesListSelected;
                visitReceived.estado = 4;
                BlocProvider.of<VisitBloc>(context)
                    .add(UpdateVisitEvent(visit: visitReceived));
              }
            }
          }
        }
      }
    }
  }

  saveData() {
    List<String> _daysListSelected = [];
    List<String> _turnesListSelected = [];
    for (var i = 0; i < _days.length; i++) {
      if (_days[i].value ?? false) {
        _daysListSelected.add(_days[i].description ?? '');
      }
    }
    for (var i = 0; i < _turnes.length; i++) {
      if (_turnes[i].value ?? false) {
        _turnesListSelected.add(_turnes[i].description ?? '');
      }
    }
    WService.diasDisponibles =
        (_daysListSelected.isNotEmpty) ? _daysListSelected as List : [];
    WService.horasDisponibles =
        (_turnesListSelected.isNotEmpty) ? _turnesListSelected as List : [];
    return true;
  }
}
