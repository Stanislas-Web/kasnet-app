import 'package:un/blocs/bloc/agent_bloc/agent_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/common/inputs/custom_input.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_agent.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:un/styles/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitAgent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AgentBloc>(
          create: (_) => AgentBloc(agentLogic: SimpleAgent()),
        ),
        BlocProvider<VisitBloc>(
          create: (_) => VisitBloc(visitLogic: SimpleVisit()),
        )
      ],
      child: VisitAgentSFull(),
    );
  }
}

class VisitAgentSFull extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _VisitAgentState();
}

class _VisitAgentState extends State<VisitAgentSFull> {
  late String codeStore;
  GlobalKey key = GlobalKey();

  late TextEditingController enterpriseController;
  late FocusNode enterpriseNode;

  late TextEditingController enterpriseFakeController;
  late FocusNode enterpriseFakeNode;

  late TextEditingController enterpriseFakeController2;
  late FocusNode enterpriseFakeNode2;

  bool isValidateInputEF = false;
  bool isSelectedItem = false;
  bool isLoadingVisit = false;
  bool isLoadingAgent = false;
  bool isPressed = false;

  Color stateItem = PrimaryThemeColor;
  Color colorState = Colors.black;
  late GoogleSignIn _googleSignIn;

  List<String> _collectionSuggestionOne = [];
  List<String> _collectionSuggestionTwo = [];
  List<String> _collectionCurrent = [];

  late int state;
  BuildContext? contextLB;  // Rendre nullable

  var _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    enterpriseController = TextEditingController();
    enterpriseNode = FocusNode();
    enterpriseFakeController = TextEditingController();
    enterpriseFakeNode = FocusNode();
    enterpriseFakeController2 = TextEditingController();
    enterpriseFakeNode2 = FocusNode();
    enterpriseFakeController.addListener(validateInputEF);
    getSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    enterpriseController.dispose();
    enterpriseFakeController.dispose();
    enterpriseNode.dispose();
    enterpriseFakeNode.dispose();
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: PrimaryThemeColor,
        title: Text("Recherche d'agents", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.input, color: Colors.white),
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
          })
        ],
      ),
    );
  }

  Widget _body(double screenHeight, double screenWidth, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, right: 14, left: 14),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Padding(padding: const EdgeInsets.all(0.0)),
              subtitle: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    child: BlocListener<AgentBloc, AgentState>(
                      listener: (context, state) {
                        if (state is TokenErrorInAgentState) {
                          WService.clearPref();
                          Map obj = {
                            'message': 'Token invalide. Veuillez vous reconnecter'
                          };
                          Navigator.pushNamed(
                            context,
                            LoginViewRoute,
                            arguments: obj,
                          );
                        }
                        if (state is ErrorInAgentState) {
                          SnackBar(
                              content: Text(state.response,
                                  style: SnackBarErrorTextStyle,
                                  textAlign: TextAlign.center));
                        }
                        if (state is GetAgentsState) {
                          _collectionSuggestionOne = [];
                          _collectionSuggestionTwo = [];
                          _collectionCurrent = [];
                          for (var item in state.agents) {
                            String nameTest = (item.codigo ?? '') +
                                "\u{02D7}" +
                                (item.nombreComercio ?? '') +
                                "\u{02D7}" +
                                (item.estado?.nombre ?? '') +
                                "";
                            _collectionSuggestionTwo.add(nameTest);
                          }
                        }
                        if (state is LoadingGetAgentState) {
                          setState(() {
                            isLoadingAgent = true;
                          });
                        } else {
                          setState(() {
                            isLoadingAgent = false;
                          });
                        }
                      },
                      child: BlocBuilder<AgentBloc, AgentState>(
                          builder: (context, state) {
                        return Column(children: <Widget>[
                          Stack(
                            alignment: AlignmentDirectional.center,
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                width: screenWidth * 0.90,
                                height: 100,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("ID/Code de l'agent*",
                                        style: LabelBlueBoldInputTextStyle,
                                        textAlign: TextAlign.start),
                                    _inputEnterpriseFake(screenWidth),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height:
                                (_collectionSuggestionTwo.length > 0) ? 200 : 0,
                            width: screenWidth * 0.70,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: SingleChildScrollView(
                              child: (_collectionSuggestionTwo.length <= 0)
                                  ? Container()
                                  : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          _collectionSuggestionTwo.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _resultPredictive(context,
                                            _collectionSuggestionTwo[index]);
                                      }),
                            ),
                          ),
                        ]);
                      }),
                    ),
                  )),
            ),
            (isLoadingAgent)
                ? SizedBox(
                    height: (_collectionSuggestionTwo.length > 0) ? 0 : 200,
                    width: (_collectionSuggestionTwo.length > 0) ? 0 : 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          backgroundColor: SecondaryThemeColor,
                          strokeWidth: 5.0,
                        ),
                      ],
                    ))
                : Container(
                    height: (_collectionSuggestionTwo.length > 0) ? 0 : 200),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.14, right: 14, left: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "ÉTATS DE L'AGENT",
                    textAlign: TextAlign.start,
                    style: SemiTitleLightTextStyle,
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: screenWidth * 0.85,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: PrimaryThemeColor),
                            ),
                            Text("Installé",
                                style: LabelSMBlueNormalInputTextStyle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center),
                          ],
                        ),
                        SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromRGBO(52, 168, 83, 1)),
                            ),
                            Text("Pré-agent",
                                style: LabelSMBlueNormalInputTextStyle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center)
                          ],
                        ),
                        SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromRGBO(233, 67, 53, 1)),
                            ),
                            Text("Inactif",
                                style: LabelSMBlueNormalInputTextStyle,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.center)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 0)
          ],
        ),
      ),
    );
  }

  Widget _resultPredictive(context, item) {
    _collectionCurrent.add(item);
    _collectionSuggestionOne.add(item);
    List<String> dataStore = item.toString().split("\u{02D7}");
    String codeStore = dataStore[0];
    String nameStore = dataStore[1];
    String stateStore = dataStore[2];
    if (stateStore == "BAJA") {
      stateItem = Color.fromRGBO(233, 67, 53, 1);
    } else if (stateStore == "PREAGENTE") {
      stateItem = Color.fromRGBO(52, 168, 83, 1);
    } else if (stateStore == "INSTALADO") {
      stateItem = PrimaryThemeColor;
    }
    return Material(
      color: SecondaryThemeColor,
      child: InkWell(
        hoverColor: stateItem,
        onTapDown: (val) {},
        onLongPress: () {},
        onTapCancel: () {},
        onHighlightChanged: (val) {},
        onHover: (val) {},
        onTap: () {
          setState(() {
            _selectAgent(
                contextSnack: context, code: codeStore, name: nameStore);
            if (state == 0) {
              colorState = Color.fromRGBO(233, 67, 53, 1);
            } else if (state == 1) {
              colorState = Color.fromRGBO(52, 168, 83, 1);
            } else if (state == 2) {
              colorState = PrimaryThemeColor;
            }
            enterpriseFakeController.text = codeStore + " " + nameStore;
            _collectionCurrent = [];
            _collectionSuggestionTwo = [];
            enterpriseFakeNode.unfocus();
            enterpriseFakeNode.requestFocus();
            isSelectedItem = true;
            isValidateInputEF = false;
            isLoadingAgent = false;
            _nextPage(contextSnack: context);
          });
        },
        child: Container(
          color: (isPressed) ? SecondaryThemeColor : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          codeStore + " - " + nameStore,
                          style: TextStyle(
                              fontFamily: DefaultFontFamily,
                              fontSize: BodyTextSize,
                              fontWeight: FontWeight.w500,
                              color: stateItem),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputEnterpriseFake(double screenWidth) {
    return CustomInputField(
      textColor: colorState,
      maxLength: 6,
      hintText: "",
      isRequired: true,
      inputTypeInfo: "number",
      borderColor: PrimaryThemeColor,
      width: screenWidth * 0.7,
      heightFont: 1.0,
      inputType: TextInputType.number,
      errorMsgInputType: "",
      controller: enterpriseFakeController,
      currentNode: enterpriseFakeNode,
      isLastInput: true,
      focus: false,
      iconSufix: Icon(Icons.search),
    );
  }

  void validateInputEF() {
    if (enterpriseFakeController.text.length >= 3 &&
        enterpriseFakeController.text.length <= 6) {
      setState(() {
        BlocProvider.of<AgentBloc>(context)
            .add(GetAgentsEvent(codeStore: enterpriseFakeController.text));
        isValidateInputEF = true;
      });
    } else if (enterpriseFakeController.text.length < 3) {
      setState(() {
        _collectionCurrent = [];
        _collectionSuggestionTwo = [];
        isValidateInputEF = false;
        isLoadingAgent = false;
        isSelectedItem = false;
        stateItem = PrimaryThemeColor;
        colorState = Colors.black;
      });
    } else {
      setState(() {
        _collectionCurrent = [];
        _collectionSuggestionTwo = [];
        isValidateInputEF = false;
        isLoadingAgent = false;
      });
    }
  }

  Widget _loading(screenHeight, screenWidth, contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        if (state is TokenErrorInVisitState) {
          WService.clearPref();
          _googleSignIn.signOut();
          Map obj = {'message': 'Token invalide. Veuillez vous reconnecter'};
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

        if (state is RegisterVisitState) {
          if (isSelectedItem) {
            enterpriseFakeController.text =
                enterpriseFakeController.text.split(" ")[0];
            WService.stateAgent = this.state;
            if (this.state == 0) {
              Map obj = {"visit": state.visit, "stateStore": true};
              Navigator.pushNamed(
                context,
                StateAgentViewRoute,
                arguments: obj,
              );
            } else {
              enterpriseFakeController.text =
                  enterpriseFakeController.text.split(" ")[0];
              Map obj = {"visit": state.visit, "stateStore": false};
              Navigator.pushNamed(
                context,
                StateAgentViewRoute,
                arguments: obj,
              );
            }
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

  void _selectAgent(
      {required BuildContext contextSnack, String? code, String? name}) async {
    if ((code != null)) {
      List<String> stateStoreSplit;
      String stateStore;
      for (var item in _collectionSuggestionOne) {
        stateStoreSplit = item.split("\u{02D7}");
        if (stateStoreSplit[0] + stateStoreSplit[1] == (code ?? '') + (name ?? '')) {
          stateStore = stateStoreSplit[2];
          setState(() {
            if (stateStore == "BAJA") {
              state = 0;
            } else if (stateStore == "PREAGENTE") {
              state = 1;
            } else if (stateStore == "INSTALADO") {
              state = 2;
            } else {
              state = 0;
            }
          });
          break;
        }
      }
    } else {
      CustomSnackbar.snackBar(
          contextSnack: contextSnack,
          isError: true,
          message: "Veuillez sélectionner un agent");
    }
  }

  void _nextPage({required BuildContext contextSnack}) {
    if ((enterpriseFakeController.text.length >= 3) && isSelectedItem) {
      var codeStoreSplit = enterpriseFakeController.text.split("\u{02D7}");
      String codeStore = codeStoreSplit[0].trim();
      List<String> stateStoreSplit;
      String stateStore;
      for (var item in _collectionSuggestionOne) {
        stateStoreSplit = item.split("\u{02D7}");
        if (stateStoreSplit[0] + " " + stateStoreSplit[1] ==
            enterpriseFakeController.text) {
          stateStore = stateStoreSplit[2];
          setState(() {
            if (stateStore == "BAJA") {
              state = 0;
            } else if (stateStore == "PREAGENTE") {
              state = 1;
            } else if (stateStore == "INSTALADO") {
              state = 2;
            } else {
              state = 0;
            }
          });
          BlocProvider.of<VisitBloc>(contextSnack)
              .add(RegisterVisitEvent(codeStore: codeStore, state: state));
          break;
        }
      }
    } else {
      CustomSnackbar.snackBar(
          contextSnack: contextSnack,
          isError: true,
          message: "Veuillez sélectionner un agent");
    }
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    codeStore = (prefs.getString('CODESTORE') == null)
        ? ""
        : prefs.getString('CODESTORE') ?? '';
    if (codeStore.isNotEmpty) {
      setState(() {
        if (codeStore.isNotEmpty) {
          enterpriseFakeController.text = codeStore;
        }
      });
    }
    await WService.clearPref();
    return;
  }
}
