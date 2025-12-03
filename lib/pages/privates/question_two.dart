import 'package:un/blocs/bloc/question_bloc/question_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_scrollbar.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/common/inputs/custom_input.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_question.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/models/answer.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionTwoView extends StatelessWidget {
  final bool isDown;
  final Visit visitReceived;

  const QuestionTwoView({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<QuestionBloc>(
          create: (_) => QuestionBloc(questionLogic: SimpleQuestion())),
      BlocProvider<VisitBloc>(
          create: (_) => VisitBloc(visitLogic: SimpleVisit()))
    ], child: QuestionTwoSFull(isDown: isDown, visitReceived: visitReceived));
  }
}

class QuestionTwoSFull extends StatefulWidget {
  final bool isDown;
  final Visit visitReceived;

  const QuestionTwoSFull({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);
  @override
  _QuestionTwoState createState() =>
      _QuestionTwoState(visitReceived: visitReceived);
}

class _QuestionTwoState extends State<QuestionTwoSFull> {
  final Visit visitReceived;
  GlobalKey key = GlobalKey();
  bool _isLoading = false;
  String _titleQO = "";
  late String _isMultiple;
  late String _state;
  late String _dateCreation;
  bool _isAnyAnsweOther = false;
  late int idQuestion;
  List<Answer> _questionList = [];
  static final TextEditingController otherAnswerController =
      new TextEditingController();
  static final FocusNode otherAnswerNode = FocusNode();
  var _scaffoldKey;
  bool isNotNinguno = true;
  _QuestionTwoState({required this.visitReceived});
  late BuildContext contextLB;
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    BlocProvider.of<QuestionBloc>(context).add(GetQuestionsEvent());
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

  Widget _body(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
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
              child: SingleChildScrollViewWithScrollbar(
                  scrollbarColor: PrimaryThemeColor,
                  child: SingleChildScrollView(
                      child: _containerListCheck(contextSnack)))),
          SizedBox(height: 15),
          SizedBox(height: 15),
          _btnNextStep(screenWidth, contextSnack)
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
            Text("Continuar encuesta", style: SemiTitleBlueTextStyle),
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

  Widget _containerListCheck(BuildContext contextSnack) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(_titleQO,
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
                    message: "Seleccione almenos una respuesta");
              }
              if (state is GetQuestionsState) {
                List? questionTwoList = state.questions[1].tsopcionPreguntaList;
                setState(() {
                  _titleQO = state.questions[1].descripcion ?? '';
                  _isMultiple = state.questions[1].esMultiple ?? '';
                  _dateCreation = state.questions[1].fechaCreacion ?? '';
                  idQuestion = state.questions[1].id ?? 0;
                });
                if (questionTwoList != null) {
                  for (var i = 0; i < questionTwoList.length; i++) {
                  Answer answer = new Answer.fromJson(questionTwoList[i]);
                  _questionList.add(answer);
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
                      itemCount: _questionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: PrimaryThemeColor),
                                  child: Checkbox(
                                      value: _questionList[index].valor,
                                      checkColor: SecondaryThemeColor,
                                      activeColor: PrimaryThemeColor,
                                      onChanged: (_questionList[index]
                                                      .descripcion ==
                                                  "NINGUNO" &&
                                              !isNotNinguno)
                                          ? null
                                          : (val) {
                                              setState(() {
                                                int num = 0;
                                                if (_questionList[index]
                                                        .descripcion ==
                                                    "OTROS") {
                                                  if (val ?? false) {
                                                    _isAnyAnsweOther = true;
                                                  } else {
                                                    _isAnyAnsweOther = false;
                                                  }
                                                  _questionList[index].valor =
                                                      val;
                                                } else if (_questionList[index]
                                                            .descripcion !=
                                                        "NINGUNO" &&
                                                    (val ?? false)) {
                                                  _questionList[index].valor =
                                                      val;
                                                } else {
                                                  _questionList[index].valor =
                                                      val;
                                                  _isAnyAnsweOther = false;
                                                }

                                                for (var i = 0;
                                                    i < _questionList.length;
                                                    i++) {
                                                  if ((_questionList[i].valor ?? false) &&
                                                      _questionList[i]
                                                              .descripcion !=
                                                          "NINGUNO") {
                                                    num++;
                                                  }
                                                  if (i >=
                                                      _questionList.length -
                                                          1) {
                                                    if (num >= 1) {
                                                      isNotNinguno = false;
                                                    } else {
                                                      isNotNinguno = true;
                                                    }
                                                  }
                                                }
                                              });
                                            }),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        int numIsNotNinguno = 0;

                                        if (_questionList[index].descripcion ==
                                            "OTROS") {
                                          if (!(_questionList[index].valor ?? false)) {
                                            _isAnyAnsweOther = true;
                                          } else {
                                            _isAnyAnsweOther = false;
                                          }
                                          _questionList[index].valor =
                                              !(_questionList[index].valor ?? false);
                                        } else if (_questionList[index]
                                                    .descripcion !=
                                                "NINGUNO" &&
                                            !(_questionList[index].valor ?? false)) {
                                          _questionList[index].valor =
                                              !(_questionList[index].valor ?? false);
                                        } else {
                                          _questionList[index].valor =
                                              !(_questionList[index].valor ?? false);
                                          _isAnyAnsweOther = false;
                                        }

                                        for (var i = 0;
                                            i < _questionList.length;
                                            i++) {
                                          if ((_questionList[i].valor ?? false) &&
                                              _questionList[i].descripcion !=
                                                  "NINGUNO") {
                                            numIsNotNinguno++;
                                          }
                                          if ((_questionList[i].valor ?? false) &&
                                              _questionList[i].descripcion ==
                                                  "NINGUNO") {}

                                          if ((_questionList[i].valor ?? false) &&
                                              _questionList[i].descripcion !=
                                                  "OTROS") {}
                                          if ((_questionList[i].valor ?? false) &&
                                              _questionList[i].descripcion ==
                                                  "OTROS") {}

                                          if (i >= _questionList.length - 1) {
                                            if (numIsNotNinguno >= 1) {
                                              isNotNinguno = false;
                                            } else {
                                              isNotNinguno = true;
                                            }
                                          }
                                        }
                                      });
                                    },
                                    child: Text(
                                        _questionList[index].descripcion,
                                        style: LabelSMBlueNormalInputTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true)),
                                SizedBox(width: 10),
                                (_isAnyAnsweOther &&
                                        _questionList[index].descripcion ==
                                            "OTROS")
                                    ? _inputOther()
                                    : Container()
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
              message: "Seleccione almenos una respuesta");
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
        if (state is TokenErrorInVisitState) {
          WService.clearPref();
          Map obj = {'message': 'Token inválido. Inicie sesión'};
          Navigator.pushNamed(
            context,
            LoginViewRoute,
            arguments: obj,
          );
        }

        if (state is LoadingVisitState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is ErrorInVisitState) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Seleccione almenos una respuesta");
        }
        if (state is UpdateVisitState) {
          Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
          Navigator.pushNamed(context, QuestionThreeViewRoute, arguments: obj);
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
    List<Answer> _questionListSelected = [];
    Visit visit = new Visit();
    visit = visitReceived;
    String answer = "";
    for (var i = 0; i < _questionList.length; i++) {
      if (_questionList[i].valor ?? false) {
        answer += _questionList[i].descripcion + "|";
        _questionListSelected.add(_questionList[i]);
      }
      if (i >= _questionList.length - 1) {
        if (_questionListSelected.length <= 0) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Seleccione al menos una respuesta");
          break;
        } else {
          Map obj = {
            "tppregunta": {
              "descripcion":
                  "COMPETENCIA (Otras redes con las que trabaja el agente, puede ingresar mas de 1)",
              "esMultiple": _isMultiple,
              "estado": _state,
              "fechaCreacion": _dateCreation,
              "tsopcionPreguntaList": []
            }
          };
          _validateForCheck(
              questionListSelected: _questionListSelected,
              obj: obj,
              visit: visit,
              answer: answer);
        }
      }
    }
  }

  void _validateForCheck(
      {required List<Answer> questionListSelected,
      required Map<dynamic, dynamic> obj,
      required Visit visit,
      required String answer}) {
    for (var i = 0; i < questionListSelected.length; i++) {
      Map subObj = {
        "id": questionListSelected[i].id,
        "valor": questionListSelected[i].descripcion
      };
      obj["tppregunta"]["tsopcionPreguntaList"].add(subObj);
      if (i >= questionListSelected.length - 1) {
        Map obj2 = {
          "tppregunta": {
            "descripcion": _titleQO,
            "esMultiple": _isMultiple,
            "estado": _state,
            "fechaCreacion": _dateCreation,
            "tsopcionPreguntaList": obj["tppregunta"]["tsopcionPreguntaList"]
          }
        };
        if (visit.trpreguntaXvisitaList != null && visit.trpreguntaXvisitaList!.length == 0) {
          if (0 >= (visit.trpreguntaXvisitaList?.length ?? 0) - 2) {
            visit.trpreguntaXvisitaList!.add(obj2);
            BlocProvider.of<VisitBloc>(context).add(UpdateQuestionVisitEvent(
                visit: visit,
                numQuestion: 1,
                answer: answer,
                idQuestion: idQuestion));
            break;
          }
        } else {
          if (visit.trpreguntaXvisitaList != null) {
            for (var i = 0; i < visit.trpreguntaXvisitaList!.length; i++) {
              if (i >= visit.trpreguntaXvisitaList!.length - 3) {
                if (visit.trpreguntaXvisitaList!.length > 1) {
                  if (_titleQO ==
                      visit.trpreguntaXvisitaList![1]['tppregunta']
                          ['descripcion']) {
                    visit.trpreguntaXvisitaList![1] = obj2;
                  } else {
                    visit.trpreguntaXvisitaList!.add(obj2);
                  }
                } else {
                  visit.trpreguntaXvisitaList!.add(obj2);
                }
              BlocProvider.of<VisitBloc>(context).add(UpdateQuestionVisitEvent(
                  visit: visit,
                  numQuestion: 1,
                  answer: answer,
                  idQuestion: idQuestion));
              break;
            }
          }
          }
        }
      }
    }
  }

  Future<Null> getSharedPrefs() async {
    if (WService.questionSelected.isNotEmpty) {
      setState(() {
        for (var j = 0; j < WService.questionSelected.length; j++) {
          for (var i = 0; i < _questionList.length; i++) {
            Map pro = WService.questionSelected[j];
            var pro2 = pro['tppregunta']?['tsopcionPreguntaList'];
            if (pro2 != null) {
              for (var k = 0; k < pro2.length; k++) {
                if (_questionList[i].descripcion == pro2[k]['valor']) {
                  _questionList[i].valor = true;
                }
              }
            }
          }
        }
      });
    }
  }
}
