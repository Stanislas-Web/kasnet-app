import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/models/generic.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StateAgentView extends StatelessWidget {
  final Visit visitReceived;
  final bool isDown;
  final String codeStore;

  const StateAgentView(
      {Key? key, required this.isDown, required this.codeStore, required this.visitReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<VisitBloc>(
          create: (_) => VisitBloc(visitLogic: SimpleVisit())),
    ], child: StateAgentSFull(isDown: isDown, codeStore: codeStore, visitReceived: visitReceived));
  }
}

class StateAgentSFull extends StatefulWidget {
  final bool isDown;
  final String codeStore;
  final Visit visitReceived;

  const StateAgentSFull(
      {Key? key, required this.isDown, required this.codeStore, required this.visitReceived})
      : super(key: key);
  @override
  _StateAgentState createState() =>
      _StateAgentState(visitReceived: visitReceived);
}

class _StateAgentState extends State<StateAgentSFull> {
  late ScrollController scrollController;

  final Visit visitReceived;

  // AutoCompleteTextField removed - deprecated package
  // GlobalKey<AutoCompleteTextFieldState<dynamic>> key = GlobalKey();

  late String previousState;
  String _stateText = "Seleccione Estado";
  bool isLoadingVisit = false;

  late BuildContext contextLB;

  List<Generic> _stateList = [];
  List<String> _stateListString = [];
  Generic state1 = Generic(description: "Abierto", value: false);
  Generic state2 = Generic(description: "Cerrado", value: false);
  Generic stateSelected =
      Generic(description: "Seleccione estado", value: false);
  String selectedItem = "Seleccione estado";

  var _scaffoldKey;
  late GoogleSignIn _googleSignIn;

  _StateAgentState({required this.visitReceived});

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _stateList.add(state1);
    _stateList.add(state2);
    _stateListString.add(state1.description ?? '');
    _stateListString..add(state2.description ?? '');
    WService.clearPref();
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
        title: Text("Visita Agente"),
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
        ],
      ),
    );
  }

  Widget _body(double screenHeight, double screenWidth, contextSnack) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 25),
          Container(
              width: screenWidth * 0.90,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 5, color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15, top: 15, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Text("Estado en el que se encontró la tienda",
                              style: LabelBlueBoldInputTextStyle,
                              textAlign: TextAlign.start),
                        ),
                        _cboStateAgent(
                            contextSnack: contextSnack,
                            screenWidth: screenWidth)
                      ],
                    ),
                  ),
                ],
              )),
          SizedBox(height: screenHeight * 0.35),
          _btnNextStep(screenWidth, contextSnack),
        ]);
  }

  Widget _loading(screenHeight, screenWidth, contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
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

        (state is LoadingVisitState)
            ? isLoadingVisit = true
            : isLoadingVisit = false;

        if (state is UpdateVisitState) {
          if (_stateText == "Cerrado") {
            Map obj = {
              'visit': state.visit,
              'stateStore': widget.isDown,
            };
            Navigator.pushNamed(context, LocationAgentViewRoute,
                arguments: obj);
          } else if (widget.isDown) {
            Map obj = {
              'visit': state.visit,
              'stateStore': widget.isDown,
            };
            Navigator.pushNamed(context, ProccesVisitViewRoute, arguments: obj);
          } else {
            Map obj = {
              'visit': state.visit,
              'stateStore': widget.isDown,
            };
            Navigator.pushNamed(context, ProccesVisitViewRoute, arguments: obj);
          }
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return (isLoadingVisit)
              ? Center(
                  child: CustomLoading(
                      screenHeight: screenHeight, screenWidth: screenWidth),
                )
              : Container();
        },
      ),
    );
  }

  Widget _cboStateAgent({required BuildContext contextSnack, required double screenWidth}) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: 350,
          padding: EdgeInsets.only(left: 10.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0,
                  color: PrimaryThemeColor,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: false,
              child: DropdownButton<Generic>(
                elevation: 16,
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                hint: Text(_stateText, style: LabelBlueNormalInputTextStyle),
                onChanged: (Generic? value) {
                  if (value != null) {
                    _selectCboStateAgent(
                        contextSnack: contextSnack, value: value);
                  }
                },
                items: _stateList.map((Generic stateMap) {
                  return DropdownMenuItem<Generic>(
                    value: stateMap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          stateMap.description ?? '',
                          style: LabelBlueNormalInputTextStyle,
                        ),
                        SizedBox(width: screenWidth * 0.4),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
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
            Text(
                (_stateText == "Abierto")
                    ? "Seleccionar Gestión"
                    : "Ubicar tienda",
                style: SemiTitleBlueTextStyle),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () {
        if (_stateText == "" ||
            _stateText == null ||
            _stateText == "Seleccione Estado") {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Seleccione el estado de la tienda");
        } else {
          Visit visit = new Visit();
          visit = visitReceived;
          visit.estadoAgente = _stateText;
          visit.estado = 1;
          BlocProvider.of<VisitBloc>(context)
              .add(UpdateVisitEvent(visit: visit));
        }
      },
    );
  }

  void _selectCboStateAgent({required BuildContext contextSnack, required Generic value}) {
    setState(() {
      _stateText = value.description ?? '';
    });
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    previousState = prefs.getString('STATESTORESELECT') ?? '';
    if (previousState != "") {
      setState(() {
        if (state1.description == previousState)
          _selectCboStateAgent(contextSnack: context, value: state1);
        else
          _selectCboStateAgent(contextSnack: context, value: state2);
      });
    } else {
      setState(() {
        _selectCboStateAgent(contextSnack: context, value: stateSelected);
      });
    }
  }
}
