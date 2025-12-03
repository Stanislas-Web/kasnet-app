import 'package:un/blocs/bloc/question_bloc/question_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/common/inputs/custom_input.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_question.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/models/answer_other.dart';
import 'package:un/models/question.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class QuestionFourView extends StatelessWidget {
  final bool isDown;
  final Visit visitReceived;

  const QuestionFourView({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<QuestionBloc>(
          create: (_) => QuestionBloc(questionLogic: SimpleQuestion())),
      BlocProvider<VisitBloc>(
          create: (_) => VisitBloc(visitLogic: SimpleVisit()))
    ], child: QuestionFourSFull(isDown: isDown, visitReceived: visitReceived));
  }
}

class QuestionFourSFull extends StatefulWidget {
  final bool isDown;
  final Visit visitReceived;

  const QuestionFourSFull({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);
  @override
  _QuestionFourState createState() =>
      _QuestionFourState(visitReceived: visitReceived);
}

class _QuestionFourState extends State<QuestionFourSFull> {
  bool lastQuestion = false;
  int sendedQuestion = 0;
  final Visit visitReceived;
  GlobalKey key = GlobalKey();
  bool _isLoading = false;
  bool _isAnyAnsweOther = false;

  AnswerOther answero1 = new AnswerOther(
      id: 1,
      descripcion: "¿Cambió su clave para hacer operaciones?",
      valor: "");
  AnswerOther answero2 = new AnswerOther(
      id: 2, descripcion: "¿Califica para Jalavista?", valor: "");
  AnswerOther answero3 =
      new AnswerOther(id: 3, descripcion: "¿Califica para Banner?", valor: "");
  List<AnswerOther> _questionList = [];
  List<Question> _answerList = [];
  static final TextEditingController otherAnswerController =
      new TextEditingController();
  static final FocusNode otherAnswerNode = FocusNode();
  var _scaffoldKey;
  bool isNotNinguno = true;
  bool isNinguno = false;
  _QuestionFourState({required this.visitReceived});
  int group = 1;
  int value = 0;
  int groupTest = 1;
  int valueTest = 1;
  List<int> listPrueba = [];
  late BuildContext contextLB;

  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    getSharedPrefs();
    BlocProvider.of<QuestionBloc>(context).add(GetQuestionsEvent());
  }

  Future<Null> getSharedPrefs() async {
    if (WService.questionSelected.isNotEmpty) {
      setState(() {
        for (var j = 3; j < WService.questionSelected.length; j++) {
          for (var i = 0; i < _answerList.length; i++) {
            Map pro = WService.questionSelected[j];
            var pro2 = pro['tppregunta']?['descripcion'];
            if (pro2 != null) {
              for (var k = 0; k < pro2.length; k++) {
                if (_answerList[i].descripcion == pro2 && _answerList[i].tsopcionPreguntaList != null) {
                  _answerList[i].tsopcionPreguntaList![0]['group'] =
                      pro['tppregunta']['valor'] == "No" ? 2 : 1;
                  _answerList[i].valor = pro['tppregunta']['valor'];
                }
              }
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
    value = 0;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: PrimaryThemeColor,
        title: Text("Encuesta"),
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
          _verifyUpdateVisit(contextLB),
        ],
      ),
    );
  }

  Widget _body(double screenHeight, double screenWidth, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 25),
          Container(
              width: screenWidth - 50,
              height: screenHeight * 0.575,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 5, color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              child:
                  SingleChildScrollView(child: _containerListCheck(contextLB))),
          SizedBox(height: 15),
          _btnNextStep(screenWidth, context),
          SizedBox(height: 0)
        ],
      ),
    );
  }

  Widget _btnNextStep(double screenWidth, BuildContext contextSnack) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: SecondaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
      ),
      child: Container(
        width: screenWidth * 0.6,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Ubicar tienda", style: SemiTitleBlueTextStyle),
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

  Widget _containerListCheck(contextSnack) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text("PREGUNTAS ADICIONALES",
                style: LabelBlueBoldInputTextStyle, textAlign: TextAlign.start),
          ),
          BlocListener<QuestionBloc, QuestionState>(
            listener: (context, state) {
              if (state is TokenErrorInQuestionState) {
                WService.clearPref();
                Map obj = {'message': 'Token inválido. Inicie sesión'};
                Navigator.pushNamed(
                  context,
                  LoginViewRoute,
                  arguments: obj,
                );
              }
              if (state is ErrorInQuestionState) {
                CustomSnackbar.snackBar(
                    contextSnack: contextSnack,
                    isError: true,
                    message: state.response);
              }
              if (state is GetQuestionsState) {
                for (var i = 0; i < state.questions.length; i++) {
                  int _id = 0;
                  if (i > 2 && state.questions[i].tsopcionPreguntaList != null) {
                    _id++;
                    state.questions[i].tsopcionPreguntaList![0]['id'] = _id;
                    _id++;
                    state.questions[i].tsopcionPreguntaList![1]['id'] = _id;
                    state.questions[i].tsopcionPreguntaList![0]['group'] = 0;
                    state.questions[i].tsopcionPreguntaList![1]['group'] = 0;
                    if (state.questions[i].tsopcionPreguntaList!.length > 2) {
                      _id++;
                      state.questions[i].tsopcionPreguntaList![2]['id'] = _id;
                      _id++;
                      state.questions[i].tsopcionPreguntaList![3]['id'] = _id;
                    }
                    _answerList.add(state.questions[i]);
                    for (var x = 0; x < _answerList.length; x++) {
                      _answerList[x].valor = "";
                    }
                  }
                }
                getSharedPrefs();
              }
            },
            child: BlocBuilder<QuestionBloc, QuestionState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _answerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        listPrueba.add(index + 1);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                onTap: () {},
                                child: Text(_answerList[index].descripcion ?? '',
                                    style: LabelSMBlueNormalInputTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true)),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        (_answerList[index]
                                                        .tsopcionPreguntaList?[0]
                                                    ?['valor'] ==
                                                null)
                                            ? "Si"
                                            : _answerList[index]
                                                    .tsopcionPreguntaList![0]
                                                ['valor'],
                                        style: LabelBlueNormalInputTextStyle),
                                    Radio(
                                      groupValue: _answerList[index]
                                          .tsopcionPreguntaList![0]['group'],
                                      value: _answerList[index]
                                          .tsopcionPreguntaList![0]['id'],
                                      onChanged: (val) {
                                        setState(() {
                                          _answerList[index]
                                                  .tsopcionPreguntaList![0]
                                              ['group'] = val;
                                          _answerList[index].valor =
                                              _answerList[index]
                                                      .tsopcionPreguntaList![0]
                                                  ['valor'];
                                        });
                                      },
                                    ),
                                    Text(
                                        (_answerList[index]
                                                        .tsopcionPreguntaList?[1]
                                                    ?['valor'] ==
                                                null)
                                            ? "No"
                                            : _answerList[index]
                                                    .tsopcionPreguntaList![1]
                                                ['valor'],
                                        style: LabelBlueNormalInputTextStyle),
                                    Radio(
                                      groupValue: _answerList[index]
                                          .tsopcionPreguntaList![0]['group'],
                                      value: _answerList[index]
                                          .tsopcionPreguntaList![1]['id'],
                                      onChanged: (val) {
                                        setState(() {
                                          _answerList[index]
                                                  .tsopcionPreguntaList![0]
                                              ['group'] = val;
                                          _answerList[index]
                                              .valor = _answerList[index]
                                                          .tsopcionPreguntaList?[
                                                      1]?['valor'] ??
                                                  "No";
                                        });
                                      },
                                    ),
                                    (_answerList[index]
                                                .tsopcionPreguntaList ==
                                            null ||
                                        _answerList[index]
                                                .tsopcionPreguntaList!
                                                .length <
                                            3)
                                        ? Container()
                                        : Text(
                                            (_answerList[index]
                                                            .tsopcionPreguntaList?[
                                                        2]?['valor'] ==
                                                    null)
                                                ? "No"
                                                : _answerList[index]
                                                        .tsopcionPreguntaList![2]
                                                    ['valor'],
                                            style:
                                                LabelBlueNormalInputTextStyle),
                                    (_answerList[index]
                                                .tsopcionPreguntaList ==
                                            null ||
                                        _answerList[index]
                                                .tsopcionPreguntaList!
                                                .length <
                                            3)
                                        ? Container()
                                        : Radio(
                                            groupValue: _answerList[index]
                                                    .tsopcionPreguntaList![0]
                                                ['group'],
                                            value: _answerList[index]
                                                .tsopcionPreguntaList![2]['id'],
                                            onChanged: (val) {
                                              setState(() {
                                                _answerList[index]
                                                        .tsopcionPreguntaList![0]
                                                    ['group'] = val;
                                                _answerList[index]
                                                    .valor = _answerList[index]
                                                        .tsopcionPreguntaList![2]
                                                    ['valor'];
                                              });
                                            },
                                          ),
                                    (_answerList[index]
                                                .tsopcionPreguntaList ==
                                            null ||
                                        _answerList[index]
                                                .tsopcionPreguntaList!
                                                .length <
                                            4)
                                        ? Container()
                                        : Text(
                                            (_answerList[index]
                                                            .tsopcionPreguntaList?[
                                                        3]?['valor'] ==
                                                    null)
                                                ? "No"
                                                : _answerList[index]
                                                        .tsopcionPreguntaList![3]
                                                    ['valor'],
                                            style:
                                                LabelBlueNormalInputTextStyle),
                                    (_answerList[index]
                                                .tsopcionPreguntaList ==
                                            null ||
                                        _answerList[index]
                                                .tsopcionPreguntaList!
                                                .length <
                                            4)
                                        ? Container()
                                        : Radio(
                                            groupValue: _answerList[index]
                                                    .tsopcionPreguntaList![0]
                                                ['group'],
                                            value: _answerList[index]
                                                .tsopcionPreguntaList![3]['id'],
                                            onChanged: (val) {
                                              setState(() {
                                                _answerList[index]
                                                        .tsopcionPreguntaList![0]
                                                    ['group'] = val;
                                                _answerList[index]
                                                    .valor = _answerList[index]
                                                        .tsopcionPreguntaList![3]
                                                    ['valor'];
                                              });
                                            },
                                          ),
                                  ]),
                            ),
                            SizedBox(width: 10),
                            (_isAnyAnsweOther &&
                                    _questionList[index].descripcion == "OTROS")
                                ? _inputOther()
                                : Container()
                          ],
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _loading(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<QuestionBloc, QuestionState>(
      listener: (context, state) {
        if (state is TokenErrorInQuestionState) {
          WService.clearPref();
          Map obj = {'message': 'Token inválido. Inicie sesión'};
          Navigator.pushNamed(
            context,
            LoginViewRoute,
            arguments: obj,
          );
        }
        if (state is ErrorInQuestionState) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: state.response);
        }
        if (state is LoadingInQuestionState) {
          _isLoading = true;
        } else {
          _isLoading = false;
        }
      },
      child:
          BlocBuilder<QuestionBloc, QuestionState>(builder: (context, state) {
        return (_isLoading)
            ? CustomLoading(
                screenHeight: screenHeight, screenWidth: screenWidth)
            : Container();
      }),
    );
  }

  Widget _verifyUpdateVisit(BuildContext contextSnack) {
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
        if (state is UpdateVisitState) {
          if (lastQuestion) {
            sendedQuestion = 0;
            lastQuestion = false;
            Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
            Navigator.pushNamed(context, LocationAgentViewRoute,
                arguments: obj);
          } else {
            sendQuestion(sendedQuestion++);
          }
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }

  Widget _inputOther() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CustomInputField(
        isRequired: _isAnyAnsweOther,
        inputTypeInfo: "text",
        borderColor: PrimaryThemeColor,
        width: 150,
        height: 50,
        heightFont: 1.0,
        inputType: TextInputType.text,
        errorMsgInputType: "",
        controller: otherAnswerController,
        currentNode: otherAnswerNode,
        isLastInput: true,
        focus: false,
      ),
    );
  }

  void _validateCheckProcces(contextSnack) {
    Visit visit = new Visit();
    visit = visitReceived;
    if (visit.trpreguntaXvisitaList != null && visit.trpreguntaXvisitaList!.length >= 3) {
      for (var i = 0; i < _answerList.length; i++) {
        if (_answerList[i].valor is Map) {
          _answerList[i].valor = _answerList[i].valor['valor'];
        }
        if (_answerList[i].valor.toString().isEmpty) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Completar todas las preguntas");
          return;
        }
        Map obj = {
          "tppregunta": {
            "descripcion": _answerList[i].descripcion,
            "esMultiple": _answerList[i].esMultiple,
            "estado": _answerList[i].estado,
            "valor": _answerList[i].valor,
            "fechaCreacion": _answerList[i].fechaCreacion,
            "tsopcionPreguntaList": _answerList[i].tsopcionPreguntaList
          }
        };
        if (visit.trpreguntaXvisitaList != null && visit.trpreguntaXvisitaList!.length <= 5) {
          visit.trpreguntaXvisitaList!.add(obj);
        } else if (visit.trpreguntaXvisitaList != null) {
          visit.trpreguntaXvisitaList![i + 3] = obj;
        }
      }
      sendQuestion(sendedQuestion);
    }
  }

  void sendQuestion(int i) {
    lastQuestion = visitReceived.trpreguntaXvisitaList != null && 
                   i == visitReceived.trpreguntaXvisitaList!.length - 4;
    Visit visit = new Visit();
    visit = visitReceived;
    BlocProvider.of<VisitBloc>(context).add(UpdateQuestionVisitEvent(
        visit: visit,
        numQuestion: i + 3,
        answer: _answerList[i].valor,
        idQuestion: i + 4));
  }
}
