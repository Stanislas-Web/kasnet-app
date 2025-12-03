import 'package:un/blocs/bloc/question_bloc/question_bloc.dart';
import 'package:un/common/custom_logo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:un/common/dialogs/custom_dialog_input.dart';
import 'package:un/common/dialogs/custom_dialog_list_checkbox_question.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_question.dart';
import 'package:un/models/answer.dart';
import 'package:un/models/days.dart';
import 'package:un/models/turnes.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:un/common/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<QuestionBloc>(
          create: (_) => QuestionBloc(questionLogic: SimpleQuestion()))
    ], child: QuestionSFull());
  }
}

class QuestionSFull extends StatefulWidget {
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<QuestionSFull> {
  late TextEditingController emailPrimaryController;
  FocusNode emailPrimaryNode = FocusNode();
  late TextEditingController emailSecondaryController;
  FocusNode emailSecondaryNode = FocusNode();

  late TextEditingController domainPrimaryController;
  FocusNode domainPrimaryNode = FocusNode();
  late TextEditingController domainSecondaryController;
  FocusNode domainSecondaryNode = FocusNode();

  late TextEditingController codCityPrimaryController;
  FocusNode codCityPrimaryNode = FocusNode();
  late TextEditingController codCitySecondaryController;
  FocusNode codCitySecondaryNode = FocusNode();

  late TextEditingController phonePrimaryController;
  FocusNode phonePrimaryNode = FocusNode();
  late TextEditingController phoneSecondaryController;
  FocusNode phoneSecondaryNode = FocusNode();

  late TextEditingController cellPhonePrimaryController;
  FocusNode cellPhonePrimaryNode = FocusNode();
  late TextEditingController cellPhoneSecondaryController;
  FocusNode cellPhoneSecondaryNode = FocusNode();

  late String categorySelected;
  bool isPhonePrimary = false;
  bool isPhoneSecondary = false;
  bool isTitular = false;
  bool answerQuestionQuarter = false;
  bool answerQuestionQuarter1 = false;
  bool answerQuestionQuarter2 = false;
  var _scaffoldKey;

  late String _domainSelectedPrimary;
  String _answerPrimaryText = "Seleccione ...";
  String _answerSecondaryText = "Seleccione ...";
  String _answerTertiaryText = "Seleccione ...";
  String _questionTitle = "Seleccione una respuesta";
  List<Day> _days = [];
  List<Turne> _turnes = [];
  List<Answer> _answersQOne = [];
  List<Answer> _answersQTwo = [];
  List<Answer> _answersQThr = [];
  Day lunes = new Day(description: "Lunes", value: false);
  Day martes = new Day(description: "Martes", value: false);
  Day miercoles = new Day(description: "Miercoles", value: false);
  Day jueves = new Day(description: "Jueves", value: false);
  Day viernes = new Day(description: "Viernes", value: false);
  Turne turneA = new Turne(description: "Mañana", value: false);
  Turne turneB = new Turne(description: "Tarde", value: false);

  Answer answerAQ1 = new Answer(descripcion: "NINGUNO", valor: false);
  Answer answerAQ2 = new Answer(descripcion: "BCP", valor: false);
  Answer answerAQ3 = new Answer(descripcion: "BBVA", valor: false);
  Answer answerAQ4 = new Answer(descripcion: "RED DIGITAL", valor: false);
  Answer answerAQ5 = new Answer(descripcion: "FULL CARGA", valor: false);
  Answer answerAQ6 =
      new Answer(descripcion: "BANCO DE LA NACIÓN", valor: false);
  Answer answerAQ7 = new Answer(descripcion: "INTERBANK", valor: false);
  Answer answerAQ8 = new Answer(descripcion: "SCOTIABANK", valor: false);
  Answer answerAQ9 = new Answer(descripcion: "CYRUS", valor: false);
  Answer answerAQ10 = new Answer(descripcion: "MOVILRED", valor: false);
  Answer answerAQ11 = new Answer(descripcion: "CELLPOWER", valor: false);
  Answer answerAQ12 = new Answer(descripcion: "WESTER UNION", valor: false);
  Answer answerAQ13 = new Answer(descripcion: "OTROS", valor: false);

  Answer answerAQ14 = new Answer(descripcion: "WHATSAPP", valor: false);
  Answer answerAQ15 =
      new Answer(descripcion: "CELULAR (RECIBIR LLAMADAS)", valor: false);
  Answer answerAQ16 =
      new Answer(descripcion: "CORREO ELECTRONICO / MAILING", valor: false);
  Answer answerAQ17 = new Answer(descripcion: "PAGINA WEB", valor: false);
  Answer answerAQ18 = new Answer(descripcion: "FACEBOOK", valor: false);
  Answer answerAQ19 =
      new Answer(descripcion: "APP AGENTES KASNET", valor: false);
  Answer answerAQ20 =
      new Answer(descripcion: "SUPERVISOR DE GLOBOKAS", valor: false);
  Answer answerAQ21 = new Answer(descripcion: "MENSAJE DE TEXTO", valor: false);

  Answer answerAQ22 = new Answer(descripcion: "SEGUROS", valor: false);
  Answer answerAQ23 = new Answer(descripcion: "PASAJES", valor: false);
  Answer answerAQ24 = new Answer(descripcion: "GIROS POR EL POS", valor: false);
  Answer answerAQ25 =
      new Answer(descripcion: "CREDITOS PERSONALES", valor: false);
  Answer answerAQ26 =
      new Answer(descripcion: "APERTURA DE CUENTAS", valor: false);
  Answer answerAQ27 =
      new Answer(descripcion: "TINKA Y OTROS TICKES ", valor: false);
  Answer answerAQ28 = new Answer(descripcion: "NINGUNO", valor: false);

  String inputAnswerTitle = "";
  String inputAnswerPrimaryText = "";
  String inputAnswerSelectedPrimary = "";
  //List<String> _turnes                    = ["Mañana", "Tarde"];
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    emailPrimaryController = TextEditingController();
    emailSecondaryController = TextEditingController();
    domainPrimaryController = TextEditingController();
    domainSecondaryController = TextEditingController();
    codCityPrimaryController = TextEditingController();
    codCitySecondaryController = TextEditingController();
    phonePrimaryController = TextEditingController();
    phoneSecondaryController = TextEditingController();
    cellPhonePrimaryController = TextEditingController();
    cellPhoneSecondaryController = TextEditingController();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    _days.add(lunes);
    _days.add(martes);
    _days.add(miercoles);
    _days.add(jueves);
    _days.add(viernes);
    _turnes.add(turneA);
    _turnes.add(turneB);
    _answersQOne.add(answerAQ1);
    _answersQOne.add(answerAQ2);
    _answersQOne.add(answerAQ3);
    _answersQOne.add(answerAQ4);
    _answersQOne.add(answerAQ5);
    _answersQOne.add(answerAQ6);
    _answersQOne.add(answerAQ7);
    _answersQOne.add(answerAQ8);
    _answersQOne.add(answerAQ9);
    _answersQOne.add(answerAQ10);
    _answersQOne.add(answerAQ11);
    _answersQOne.add(answerAQ12);
    _answersQOne.add(answerAQ13);

    _answersQTwo.add(answerAQ14);
    _answersQTwo.add(answerAQ15);
    _answersQTwo.add(answerAQ16);
    _answersQTwo.add(answerAQ17);
    _answersQTwo.add(answerAQ18);
    _answersQTwo.add(answerAQ19);
    _answersQTwo.add(answerAQ20);
    _answersQTwo.add(answerAQ21);

    _answersQThr.add(answerAQ22);
    _answersQThr.add(answerAQ23);
    _answersQThr.add(answerAQ24);
    _answersQThr.add(answerAQ25);
    _answersQThr.add(answerAQ26);
    _answersQThr.add(answerAQ27);
    _answersQThr.add(answerAQ28);
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
              onPressed: () {
                WService.clearPref();
                _googleSignIn.signOut(); //.disconnect();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginViewRoute, (Route<dynamic> route) => false);
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return Container(
              width: screenWidth,
              height: screenHeight,
              color: TertiaryThemeColor,
              child: _body(screenWidth, screenHeight, isKeyboard),
            );
          }),
        ],
      ),
      drawer: MenuDrawer(nameUser: ''),
    );
  }

  Widget _body(double screenWidth, double screenHeight, bool isKeyboard) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, right: 10.0, left: 10.0, bottom: 15.0),
            child: Container(
              height: screenHeight * 0.60,
              decoration: BoxDecoration(
                  color: SecondaryThemeColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      _inputRowQuestionPrimary(),
                      _inputRowQuestionSecondary(),
                      _inputRowQuestionQuarter(),
                      _inputRowQuestionTertiary(),
                      _inputRowQuestionFight(),
                      _inputRowQuestionSix(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.005,
                right: 14,
                left: 14,
                bottom: screenHeight * 0.10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _btnPreviusStep(screenWidth),
                _btnNextStep(screenWidth)
              ],
            ),
          ),
          Logo(isKeyboard: isKeyboard),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget _inputRowQuestionPrimary({
    String? agentEmail,
    bool? isEmailModifiable,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[_questionPrimary(), _itemDialogAnswerPrimary()],
    );
  }

  Widget _inputRowQuestionSecondary(
      {String? agentEmail, bool? isEmailModifiable}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _questionSecondary(),
        _itemDialogAnswerSecondary(),
      ],
    );
  }

  Widget _inputRowQuestionTertiary(
      {String? agentEmail, bool? isEmailModifiable}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _questionTertiary(),
        _itemDialogAnswerTertiary(),
      ],
    );
  }

  Widget _inputRowQuestionQuarter({String? agentEmail, bool? isEmailModifiable}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _questionQuarter(),
        _itemDialogAnswerQuarter(),
      ],
    );
  }

  Widget _inputRowQuestionFight({String? agentEmail, bool? isEmailModifiable}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _questionFight(),
        _itemDialogAnswerFight(),
      ],
    );
  }

  Widget _inputRowQuestionSix({String? agentEmail, bool? isEmailModifiable}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _questionSix(),
        _itemDialogAnswerSix(),
      ],
    );
  }

  Widget _questionPrimary() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 175,
              child: Text(
                  "COMPETENCIA(Otras redes con la que trabaja el agente, puede ingresar más de 1)",
                  style: TextStyle(
                    color: PrimaryThemeColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left)),
        ],
      ),
    );
  }

  Widget _itemDialogAnswerPrimary() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: _cboDomainPrimary(),
    );
  }

  Widget _cboDomainPrimary() {
    return Container(
      height: 45,
      width: 150,
      padding: EdgeInsets.only(left: 10.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: PrimaryThemeColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: InkWell(
        onTap: () async {
          final action = await CustomDialogListCheckboxAnswer.listSelect(
              context, _questionTitle, '', _answersQOne);
          if (action.length != 0) {
            _answerPrimaryText = "";

            for (var i = 0; i < action.length; i++) {
              if (action[i].valor ?? false) {
                setState(() async {
                  if (_answerPrimaryText == "") {
                    _answerPrimaryText = action[i].descripcion;
                  } else {
                    _answerPrimaryText =
                        _answerPrimaryText + ", " + action[i].descripcion;
                  }
                  if (action[i].descripcion == "OTROS") {
                    final actionInput = await CustomDialogInput.input(
                        context, inputAnswerTitle, '', []);
                    inputAnswerPrimaryText = actionInput ?? '';
                    inputAnswerSelectedPrimary = actionInput ?? '';
                  }
                });
              }
            }
          }
        },
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
          hint: Text(_answerPrimaryText, style: BtnBlueTextStyle),
          items: null,
          value: _domainSelectedPrimary,
          onChanged: (optionSelected) {
            setState(() {
              _domainSelectedPrimary = optionSelected ?? '';
            });
          },
        ),
      ),
    );
  }

  Widget _questionSecondary() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 175,
              child: Text(
                  "¿Cual medio de comunicación prefiere para informarse sobre las campañas,promociones y cualquier otra información?",
                  style: TextStyle(
                    color: PrimaryThemeColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left)),
        ],
      ),
    );
  }

  Widget _itemDialogAnswerSecondary() {
    return Padding(
        padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
        child: _cboDomainSecondary());
  }

  Widget _cboDomainSecondary() {
    return Container(
      height: 45,
      width: 150,
      padding: EdgeInsets.only(left: 10.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: PrimaryThemeColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: InkWell(
        onTap: () async {
          final action = await CustomDialogListCheckboxAnswer.listSelect(
              context, _questionTitle, '', _answersQTwo);
          if (action.length != 0) {
            _answerSecondaryText = "";
            for (var i = 0; i < action.length; i++) {
              if (action[i].valor ?? false) {
                setState(() {
                  if (_answerSecondaryText == "") {
                    _answerSecondaryText = action[i].descripcion;
                  } else {
                    _answerSecondaryText =
                        _answerSecondaryText + ", " + action[i].descripcion;
                  }
                });
              }
            }
          }
        },
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
          hint: Text(_answerSecondaryText, style: BtnBlueTextStyle),
          items: null,
          value: _domainSelectedPrimary,
          onChanged: (optionSelected) {
            setState(() {
              _domainSelectedPrimary = optionSelected ?? '';
            });
          },
        ),
      ),
    );
  }

  Widget _questionTertiary() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 175,
              child: Text(
                "¿Cual medio de comunicación prefiere para informarse sobre las campañas,promociones y cualquier otra información?",
                style: TextStyle(
                  color: PrimaryThemeColor,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              )),
        ],
      ),
    );
  }

  Widget _itemDialogAnswerTertiary() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: _cboDomainTertiary(),
    );
  }

  Widget _cboDomainTertiary() {
    return Container(
      height: 45,
      width: 150,
      padding: EdgeInsets.only(left: 10.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: PrimaryThemeColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: InkWell(
        onTap: () async {
          final action = await CustomDialogListCheckboxAnswer.listSelect(
              context, _questionTitle, '', _answersQThr);
          if (action.length != 0) {
            _answerTertiaryText = "";
            for (var i = 0; i < action.length; i++) {
              if (action[i].valor ?? false) {
                setState(() {
                  if (_answerTertiaryText == "") {
                    _answerTertiaryText = action[i].descripcion;
                  } else {
                    _answerTertiaryText =
                        _answerTertiaryText + ", " + action[i].descripcion;
                  }
                });
              }
            }
          }
        },
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
          hint: Text(_answerTertiaryText, style: BtnBlueTextStyle),
          items: null,
          value: _domainSelectedPrimary,
          onChanged: (optionSelected) {
            setState(() {
              _domainSelectedPrimary = optionSelected ?? '';
            });
          },
        ),
      ),
    );
  }

  Widget _questionQuarter() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 175,
              child: Text("¿Cambió su clave para hacer operaciones?",
                  style: TextStyle(
                    color: PrimaryThemeColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left)),
        ],
      ),
    );
  }

  Widget _itemDialogAnswerQuarter() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: PrimaryThemeColor),
        child: Row(children: <Widget>[
          Radio<bool>(
            value: true,
            groupValue: answerQuestionQuarter1,
            onChanged: (value) {
              setState(() {
                answerQuestionQuarter1 = value ?? false;
              });
            },
          ),
          Text("Si"),
          Radio<bool>(
            value: false,
            groupValue: answerQuestionQuarter1,
            onChanged: (value) {
              setState(() {
                answerQuestionQuarter1 = value ?? true;
              });
            },
          ),
          Text("No"),

          /* activeColor: SecondaryThemeColor,
          labelStyle: LabelSMBlueNormalInputTextStyle,
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>[
            "Si",
            "No",
          ],
          onSelected: (String selected){
            setState(() {
              answerQuestionQuarter = (selected=="Si")? true:false;
            });
          } */
        ]),
        /* RadioButtonGroup(
          activeColor: SecondaryThemeColor,
          labelStyle: LabelSMBlueNormalInputTextStyle,
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>[
            "Si",
            "No",
          ],
          onSelected: (String selected){
            setState(() {
              answerQuestionQuarter = (selected=="Si")? true:false;
            });
          }
        ), */
      ),
    );
  }

  Widget _questionFight() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 175,
              child: Text(
                "¿Califica para Jalavista?",
                style: TextStyle(
                  color: PrimaryThemeColor,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              )),
        ],
      ),
    );
  }

  Widget _itemDialogAnswerFight() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: PrimaryThemeColor),
        child: Row(children: <Widget>[
          Radio<bool>(
            value: true,
            groupValue: answerQuestionQuarter,
            onChanged: (value) {
              setState(() {
                answerQuestionQuarter = value ?? false;
              });
            },
          ),
          Text("Si"),
          Radio<bool>(
            value: false,
            groupValue: answerQuestionQuarter,
            onChanged: (value) {
              setState(() {
                answerQuestionQuarter = value ?? true;
              });
            },
          ),
          Text("No"),

          /* activeColor: SecondaryThemeColor,
          labelStyle: LabelSMBlueNormalInputTextStyle,
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>[
            "Si",
            "No",
          ],
          onSelected: (String selected){
            setState(() {
              answerQuestionQuarter = (selected=="Si")? true:false;
            });
          } */
        ]), /* RadioButtonGroup(
          activeColor: SecondaryThemeColor,
          labelStyle: LabelSMBlueNormalInputTextStyle,
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>[
            "Si",
            "No",
          ],
          onSelected: (String selected){
            setState(() {
              answerQuestionQuarter = (selected=="Si")? true:false;
            });
          }
        ), */
      ),
    );
  }

  Widget _questionSix() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 175,
              child: Text("¿Califica para Banner?",
                  style: TextStyle(
                    color: PrimaryThemeColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start)),
        ],
      ),
    );
  }

  Widget _itemDialogAnswerSix() {
    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Theme(
          data: ThemeData(unselectedWidgetColor: PrimaryThemeColor),
          child: Row(children: <Widget>[
            Radio<bool>(
              value: true,
              groupValue: answerQuestionQuarter2,
              onChanged: (value) {
                setState(() {
                  answerQuestionQuarter2 = value ?? false;
                });
              },
            ),
            Text("Si"),
            Radio<bool>(
              value: false,
              groupValue: answerQuestionQuarter2,
              onChanged: (value) {
                setState(() {
                  answerQuestionQuarter2 = value ?? true;
                });
              },
            ),
            Text("No"),

            /* activeColor: SecondaryThemeColor,
          labelStyle: LabelSMBlueNormalInputTextStyle,
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: <String>[
            "Si",
            "No",
          ],
          onSelected: (String selected){
            setState(() {
              answerQuestionQuarter = (selected=="Si")? true:false;
            });
          } */
          ]),
        ));
  }

  Widget _btnNextStep(double screenWidth) {
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
            Text("Seguir", style: BtnBlueTextStyle),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, LocationAgentViewRoute);
      },
    );
  }

  Widget _btnPreviusStep(double screenWidth) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: SecondaryThemeColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
      ),
      child: Container(
        width: screenWidth * 0.33,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.arrow_back, color: PrimaryThemeColor),
            Text("Regresar", style: BtnBlueTextStyle)
          ],
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
