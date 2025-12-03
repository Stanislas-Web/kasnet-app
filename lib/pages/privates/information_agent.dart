import 'package:un/blocs/bloc/agent_bloc/agent_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_scrollbar.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/common/inputs/custom_input.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_agent.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/logics/string_capital.dart';
import 'package:un/models/find_agent.dart';
import 'package:un/models/generic.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InformationAgentView extends StatelessWidget {
  final String codeStore;
  final Visit visitReceived;
  final bool isDown;

  const InformationAgentView(
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
        child: InformationAgentSFull(
            codeStore: codeStore,
            visitReceived: visitReceived,
            isDown: isDown));
  }
}

class InformationAgentSFull extends StatefulWidget {
  final String codeStore;
  final Visit visitReceived;
  final bool isDown;

  const InformationAgentSFull(
      {Key? key, required this.codeStore, required this.visitReceived, required this.isDown})
      : super(key: key);
  @override
  _InformationAgentState createState() =>
      _InformationAgentState(visitReceived: visitReceived);
}

class _InformationAgentState extends State<InformationAgentSFull> {
  String address = "";
  String contact = "";
  String store = "";
  late FindAgentResponse data;

  late ScrollController scrollController;
  final Visit visitReceived;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailPrimaryController;
  FocusNode emailPrimaryNode = FocusNode();
  late TextEditingController emailSecondaryController;
  FocusNode emailSecondaryNode = FocusNode();

  late TextEditingController domainPrimaryController;
  FocusNode domainPrimaryNode = FocusNode();
  Color domainPrimaryState = PrimaryThemeColor;
  late TextEditingController domainSecondaryController;
  FocusNode domainSecondaryNode = FocusNode();
  Color domainSecondaryState = PrimaryThemeColor;

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

  late TextEditingController cellPhoneOperatorController;
  FocusNode cellPhoneOperatorNode = FocusNode();
  late TextEditingController phoneOperatorController;
  FocusNode phoneOperatorNode = FocusNode();
  late TextEditingController codCityOperatorController;
  FocusNode codCityOperatorNode = FocusNode();

  late TextEditingController nameOperatorController;
  FocusNode nameOperatorNode = FocusNode();

  late TextEditingController emailOperatorController;
  FocusNode emailOperatorNode = FocusNode();
  Color domainOperatorState = PrimaryThemeColor;

  late String categorySelected;
  bool isPhonePrimary = false;
  bool isPhoneSecondary = false;
  bool isTitular = true;
  bool isPhoneOperator = true;
  bool isLoadingVisit = false;
  bool _domainPrimaryIsError = false;
  bool _domainOperatorIsError = false;
  bool _errorMailPrimary = false;
  bool _errorPhone = false;

  String _domainPrimaryText = "";
  String _domainSecondaryText = "";
  String _domainOperatorText = "";
  List<Generic> _domains = [];
  Generic domainGmail = Generic(description: "Hotmail", value: false);
  Generic domainHotmail = Generic(description: "Gmail", value: false);
  Generic domainOther = Generic(description: "Otro", value: false);
  late BuildContext contextLB;
  var _scaffoldKey;
  int group = 1;

  late GoogleSignIn _googleSignIn;

  _InformationAgentState({required this.visitReceived});

  _scrollListener() {
    emailPrimaryNode.unfocus();
    emailSecondaryNode.unfocus();
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _domains.add(domainGmail);
    _domains.add(domainHotmail);
    _domains.add(domainOther);
    nameOperatorController = TextEditingController();
    emailPrimaryController = TextEditingController();
    emailSecondaryController = TextEditingController();
    emailOperatorController = TextEditingController();
    domainPrimaryController = TextEditingController();
    domainSecondaryController = TextEditingController();
    codCityPrimaryController = TextEditingController();
    codCitySecondaryController = TextEditingController();
    phonePrimaryController = TextEditingController();
    phoneSecondaryController = TextEditingController();
    cellPhonePrimaryController = TextEditingController();
    cellPhoneSecondaryController = TextEditingController();
    cellPhoneOperatorController = TextEditingController();
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
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: PrimaryThemeColor,
          title: Text("Datos del Agente"),
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
                child: _body(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    contextSnack: context),
              );
            }),
            Logo(isKeyboard: isKeyboard),
            _loading(screenHeight, screenWidth, contextLB),
            _loadingAgent(screenHeight, screenWidth, contextLB),
          ],
        ),
      ),
    );
  }

  Widget _body(
      {required double screenHeight, required double screenWidth, required BuildContext contextSnack}) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: screenHeight * 0.45,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollViewWithScrollbar(
                  scrollbarColor: PrimaryThemeColor,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    child: _formContainer(
                        screenHeight: screenHeight, screenWidth: screenWidth),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          _btnNextStep(screenWidth, contextSnack),
          SizedBox(height: 50)
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
                  textAlign: TextAlign.start))
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

  Widget _formContainer({required double screenWidth, required double screenHeight}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _decideIsTitular(),
          SizedBox(height: 10),
          (!isTitular) ? _inputNameOperator() : Container(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Correo Electronico Principal *",
                style: LabelBlueNormalInputTextStyle,
                overflow: TextOverflow.ellipsis),
          ),
          (isTitular)
              ? _inputRowEmailPrimary(
                  screenHeight: screenHeight, screenWidth: screenWidth)
              : _inputRowEmailOperator(
                  screenHeight: screenHeight, screenWidth: screenWidth),
          (isTitular) ? SizedBox(height: 10) : Container(),
          (isTitular)
              ? Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text("Correo Electronico Secundario",
                      style: LabelBlueNormalInputTextStyle,
                      overflow: TextOverflow.ellipsis),
                )
              : Container(),
          (isTitular)
              ? _inputRowEmailSecondary(
                  screenHeight: screenHeight, screenWidth: screenWidth)
              : Container(),
          SizedBox(height: 5),
          (isTitular) ? _decideIsPhonePrimary() : Container(),
          (isTitular)
              ? Container(
                  child: (!isPhonePrimary)
                      ? _inputCellPhonePrimary()
                      : _inputRowPhonePrimary(screenWidth: screenWidth))
              : Container(),
          (!isTitular) ? _inputCellPhoneOperator() : Container(),
          (isTitular) ? _decideIsPhoneSecondary() : Container(),
          (isTitular)
              ? Container(
                  child: (!isPhoneSecondary)
                      ? _inputCellPhoneSecondary()
                      : _inputRowSecondary(screenWidth: screenWidth))
              : Container(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _inputNameOperator({String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Nombre del Operador *", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Nombre Completo",
            isRequired: true,
            inputTypeInfo: "text",
            borderColor: PrimaryThemeColor,
            width: double.infinity,
            heightFont: 1.0,
            inputType: TextInputType.text,
            errorMsgRequired: "",
            errorMsgInputType: "",
            controller: nameOperatorController,
            currentNode: nameOperatorNode,
            nextNode: emailOperatorNode,
            isLastInput: false,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _decideIsTitular() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" Entrevistado es Titular?*",
              style: LabelBlueNormalInputTextStyle, textAlign: TextAlign.start),
          SizedBox(width: 25),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Theme(
                data: ThemeData(unselectedWidgetColor: PrimaryThemeColor),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Si",
                                style: LabelBlueNormalInputTextStyle,
                                overflow: TextOverflow.ellipsis),
                            Radio(
                              groupValue: group,
                              value: 1,
                              onChanged: (val) {
                                group = val ?? 1;
                                _changeValueIsTitular(value: val ?? 1);
                              },
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("No", style: LabelBlueNormalInputTextStyle),
                            Radio(
                              groupValue: group,
                              value: 2,
                              onChanged: (val) {
                                group = val ?? 2;
                                _changeValueIsTitular(value: val ?? 2);
                              },
                            ),
                          ]),
                    ])),
          )
        ],
      ),
    );
  }

  Widget _inputRowEmailPrimary(
      {required double screenWidth,
      required double screenHeight,
      String agentEmail = '',
      bool isEmailModifiable = true,
      dp}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _emailPrimary(screenWidth: screenWidth, screenHeight: screenHeight),
        _itemDialogDomainPrimary(screenWidth: screenWidth, screenHeight: screenHeight)
      ],
    );
  }

  Widget _inputRowEmailSecondary(
      {required double screenWidth,
      required double screenHeight,
      String agentEmail = '',
      bool isEmailModifiable = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _emailSecondary(screenWidth: screenWidth, screenHeight: screenHeight),
        _itemDialogDomainSecondary(screenWidth: screenWidth, screenHeight: screenHeight, contextSnack: context)
      ],
    );
  }

  Widget _inputRowEmailOperator(
      {required double screenWidth,
      required double screenHeight,
      String agentEmail = '',
      bool isEmailModifiable = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _emailOperator(screenWidth: screenWidth, screenHeight: screenHeight),
        _itemDialogDomainOperator(screenWidth: screenWidth, screenHeight: screenHeight, contextSnack: context)
      ],
    );
  }

  Widget _emailPrimary({required double screenWidth, required double screenHeight}) {
    return Padding(
        // padding: const EdgeInsets.only(left: 12.0, top: 0.0),
        padding: const EdgeInsets.only(left: 12.0),
        child: CustomInputField(
            hintText: "Correo electrónico principal",
            isRequired: true,
            inputTypeInfo: "email",
            borderColor: PrimaryThemeColor,
            width: screenWidth * 0.48,
            heightFont: 1.0,
            inputType: TextInputType.text,
            errorMsgInputType: "",
            errorMsgRequired: "",
            controller: emailPrimaryController,
            currentNode: emailPrimaryNode,
            nextNode: domainPrimaryNode,
            isLastInput: false,
            focus: true));
  }

  Widget _itemDialogDomainPrimary({required double screenWidth, required double screenHeight}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_cboDomainPrimary(contextSnack: context, screenWidth: screenWidth)],
      ),
    );
  }

  Widget _itemDialogDomainSecondary(
      {required double screenWidth, required double screenHeight, required BuildContext contextSnack}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: _cboDomainSecondary(contextSnack: contextSnack, screenWidth: screenWidth),
    );
  }

  Widget _itemDialogDomainOperator(
      {required double screenWidth, required double screenHeight, required BuildContext contextSnack}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: _cboDomainOperator(contextSnack: contextSnack, screenWidth: screenWidth),
    );
  }

  Widget _emailSecondary({required double screenWidth, required double screenHeight}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: CustomInputField(
        hintText: "Correo electrónico secundario",
        isRequired: false,
        inputTypeInfo: "email",
        borderColor: PrimaryThemeColor,
        width: screenWidth * 0.48,
        heightFont: 1.0,
        errorMsgInputType: "",
        inputType: TextInputType.text,
        controller: emailSecondaryController,
        currentNode: emailSecondaryNode,
        nextNode: cellPhonePrimaryNode,
        isLastInput: false,
        focus: false,
      ),
    );
  }

  Widget _emailOperator({required double screenWidth, required double screenHeight}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: CustomInputField(
        hintText: "Correo electrónico secundario",
        isRequired: true,
        inputTypeInfo: "email",
        borderColor: PrimaryThemeColor,
        width: screenWidth * 0.48,
        heightFont: 1.0,
        inputType: TextInputType.text,
        errorMsgInputType: "",
        errorMsgRequired: "",
        controller: emailOperatorController,
        currentNode: emailOperatorNode,
        nextNode: emailSecondaryNode,
        isLastInput: true,
        focus: false,
      ),
    );
  }

  Widget _decideIsPhonePrimary() {
    return Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 1.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("   ¿Teléfono principal?*",
                    style: LabelBlueNormalInputTextStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio<bool>(
                    activeColor: PrimaryThemeColor,
                    value: true,
                    groupValue: isPhonePrimary,
                    onChanged: (bool? value) {
                      setState(() {
                        isPhonePrimary = value ?? true;
                        if (isPhonePrimary)
                          codCityPrimaryNode.requestFocus();
                        else
                          cellPhonePrimaryNode.requestFocus();
                      });
                    }),
                Text("Fijo", style: LabelBlueNormalInputTextStyle),
                SizedBox(width: 20),
                Radio<bool>(
                    activeColor: PrimaryThemeColor,
                    value: false,
                    groupValue: isPhonePrimary,
                    onChanged: (bool? value) {
                      setState(() {
                        isPhonePrimary = value ?? false;
                        if (isPhonePrimary)
                          codCityPrimaryNode.requestFocus();
                        else
                          cellPhonePrimaryNode.requestFocus();
                      });
                    }),
                Text("Celular", style: LabelBlueNormalInputTextStyle),
              ],
            ),
          ],
        ));
  }

  Widget _inputCodCityPrimary(
      {required double screenWidth, String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Cód. de Ciudad", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Código ciudad",
            isRequired: true,
            inputTypeInfo: "cod", // "onlyNumber",
            borderColor: PrimaryThemeColor,
            width: screenWidth * 0.3,
            heightFont: 1.0,
            inputType: TextInputType.number,
            errorMsgInputType: "",
            errorMsgRequired: "",
            maxLength: 3,
            errorMsgMaxLength: "",
            controller: codCityPrimaryController,
            currentNode: codCityPrimaryNode,
            nextNode: phonePrimaryNode,
            isLastInput: false,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _inputPhonePrimary(
      {required double screenWidth, String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Teléfono", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Número de teléfono",
            isRequired: true,
            inputTypeInfo: "onlyNumber",
            borderColor: PrimaryThemeColor,
            width: screenWidth * 0.48,
            heightFont: 1.0,
            inputType: TextInputType.number,
            errorMsgMaxLength: "",
            errorMsgMinLength: "",
            maxLength: 7,
            minLength: 6,
            errorMsgInputType: "",
            errorMsgRequired: "",
            controller: phonePrimaryController,
            currentNode: phonePrimaryNode,
            nextNode: null,
            isLastInput: false,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _inputCellPhonePrimary({String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Celular *", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            isRequired: true,
            inputTypeInfo: "onlyNumber",
            borderColor: PrimaryThemeColor,
            width: double.infinity,
            heightFont: 1.0,
            inputType: TextInputType.number,
            errorMsgInputType: "",
            errorMsgRequired: "",
            errorMsgMaxLength: "",
            errorMsgMinLength: "",
            maxLength: 9,
            minLength: 9,
            controller: cellPhonePrimaryController,
            currentNode: cellPhonePrimaryNode,
            nextNode: cellPhoneSecondaryNode,
            isLastInput: false,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _inputCodCitySecondary(
      {required double screenWidth, String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Cód. de Ciudad", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Código de ciudad",
            isRequired: false,
            inputTypeInfo: "cod", // "onlyNumber",
            errorMsgInputType: "",
            borderColor: PrimaryThemeColor,
            width: screenWidth * 0.3,
            heightFont: 1.0,
            inputType: TextInputType.number,
            maxLength: 3,
            controller: codCitySecondaryController,
            currentNode: codCitySecondaryNode,
            nextNode: phoneSecondaryNode,
            isLastInput: false,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _inputPhoneSecondary(
      {required double screenWidth, String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Teléfono", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Número de celular",
            isRequired: false,
            inputTypeInfo: "onlyNumber",
            borderColor: PrimaryThemeColor,
            width: screenWidth * 0.48,
            heightFont: 1,
            inputType: TextInputType.number,
            maxLength: 7,
            minLength: 6,
            controller: phoneSecondaryController,
            currentNode: phoneSecondaryNode,
            nextNode: null,
            isLastInput: true,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _inputCellPhoneSecondary({String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Celular", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Número de celular",
            isRequired: false,
            inputTypeInfo: "onlyNumber",
            borderColor: PrimaryThemeColor,
            width: double.infinity,
            heightFont: 1.0,
            inputType: TextInputType.number,
            errorMsgInputType: "",
            errorMsgRequired: "",
            errorMsgMaxLength: "",
            errorMsgMinLength: "",
            maxLength: 9,
            minLength: 9,
            controller: cellPhoneSecondaryController,
            currentNode: cellPhoneSecondaryNode,
            nextNode: null,
            isLastInput: true,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _inputCellPhoneOperator({String agentEmail = '', bool isEmailModifiable = true}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Celular *", style: LabelBlueNormalInputTextStyle),
          CustomInputField(
            hintText: "Número de celular",
            isRequired: true,
            inputTypeInfo: "onlynumber",
            borderColor: PrimaryThemeColor,
            width: double.infinity,
            heightFont: 1.0,
            inputType: TextInputType.number,
            errorMsgInputType: "",
            errorMsgRequired: "",
            errorMsgMaxLength: "",
            errorMsgMinLength: "",
            maxLength: 9,
            minLength: 9,
            controller: cellPhoneOperatorController,
            currentNode: cellPhoneOperatorNode,
            nextNode: null,
            isLastInput: true,
            focus: false,
          ),
        ],
      ),
    );
  }

  Widget _decideIsPhoneSecondary() {
    return Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 2.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("   ¿Teléfono secundario?",
                    style: LabelBlueNormalInputTextStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio<bool>(
                    activeColor: PrimaryThemeColor,
                    value: true,
                    groupValue: isPhoneSecondary,
                    onChanged: (bool? value) {
                      setState(() {
                        isPhoneSecondary = value ?? true;
                        if (isPhoneSecondary)
                          codCitySecondaryNode.requestFocus();
                        else
                          cellPhoneSecondaryNode.requestFocus();
                      });
                    }),
                Text("Fijo", style: LabelBlueNormalInputTextStyle),
                SizedBox(width: 20),
                Radio<bool>(
                    activeColor: PrimaryThemeColor,
                    value: false,
                    groupValue: isPhoneSecondary,
                    onChanged: (bool? value) {
                      setState(() {
                        isPhoneSecondary = value ?? false;
                        if (isPhoneSecondary)
                          codCitySecondaryNode.requestFocus();
                        else
                          cellPhoneSecondaryNode.requestFocus();
                      });
                    }),
                Text("Celular", style: LabelBlueNormalInputTextStyle),
              ],
            ),
          ],
        ));
  }

  Widget _inputRowPhonePrimary({required double screenWidth}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _inputCodCityPrimary(screenWidth: screenWidth),
        _inputPhonePrimary(screenWidth: screenWidth),
      ],
    );
  }

  Widget _inputRowSecondary({required double screenWidth}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _inputCodCitySecondary(screenWidth: screenWidth),
        _inputPhoneSecondary(screenWidth: screenWidth),
      ],
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
            Text("Continuar Entrevista", style: SemiTitleBlueTextStyle),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () {
        _validateForm(contextSnack);
      },
    );
  }

  Widget _cboDomainPrimary({required BuildContext contextSnack, required double screenWidth}) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: (_domainPrimaryIsError || _errorMailPrimary) ? 25 : 0),
        child: Container(
          width: screenWidth * 0.3,
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
                hint: Text(_domainPrimaryText,
                    style: LabelBlueNormalInputTextStyle),
                onChanged: (Generic? value) {
                  if (value != null) {
                    _selectCboDomainPrimary(
                        contextSnack: contextSnack, value: value);
                  }
                },
                items: _domains.map((Generic stateMap) {
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

  Widget _cboDomainSecondary({required BuildContext contextSnack, required double screenWidth}) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: (false) ? 25 : 0),
        child: Container(
          width: screenWidth * 0.3,
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
                hint: Text(_domainSecondaryText,
                    style: LabelBlueNormalInputTextStyle),
                onChanged: (Generic? value) {
                  if (value != null) {
                    _selectCboDomainSecondary(
                        contextSnack: contextSnack, value: value);
                  }
                },
                items: _domains.map((Generic stateMap) {
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

  Widget _cboDomainOperator({required BuildContext contextSnack, required double screenWidth}) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            bottom:
                0), //(_domainOperatorIsError || _errorMailOperator) ? 25 : 0),
        child: Container(
          width: screenWidth * 0.3,
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
                hint: Text(_domainOperatorText,
                    style: LabelBlueNormalInputTextStyle),
                onChanged: (Generic? value) {
                  if (value != null) {
                    _selectCboDomainOperator(
                        contextSnack: contextSnack, value: value);
                  }
                },
                items: _domains.map((Generic stateMap) {
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

  Widget _loadingAgent(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<AgentBloc, AgentState>(
      listener: (context, state) {
        if (state is LoadingGetAgentState) {
          setState(() {
            isLoadingVisit = true;
          });
        } else {
          setState(() {
            isLoadingVisit = false;
          });
        }

        if (state is UpdateAgentState) {
          Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
          Navigator.pushNamed(context, InformationAgentSecondaryViewRoute,
              arguments: obj);
        }
        if (state is TokenErrorInAgentState) {
          WService.clearPref();
          Map obj = {'message': 'Token inválido. Inicie sesión'};
          Navigator.pushNamed(
            context,
            LoginViewRoute,
            arguments: obj,
          );
        }
        if (state is ErrorInAgentState) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "No se pudo actualizar la data");
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

  void _selectCboDomainPrimary({required BuildContext contextSnack, required Generic value}) {
    setState(() {
      _domainPrimaryText = value.description ?? '';
      if (_domainPrimaryText == "" ||
          _domainPrimaryText == null ||
          _domainPrimaryText == "Seleccione dominio") {
        CustomSnackbar.snackBar(
            contextSnack: contextSnack,
            isError: true,
            message: "Seleccione dominio");
      } else {
        if (value.description == "Otro") {
          if (emailPrimaryController.text.contains("@gmail")) {
            List _emailPCSplit = emailPrimaryController.text.split("@");
            String _email = _emailPCSplit[0];
            emailPrimaryController.text =
                (emailPrimaryController.text.contains("@"))
                    ? _email + "@"
                    : _email;
          } else if (emailPrimaryController.text.contains("@hotmail")) {
            List _emailPCSplit = emailPrimaryController.text.split("@");
            String _email = _emailPCSplit[0];
            emailPrimaryController.text =
                (emailPrimaryController.text.contains("@"))
                    ? _email + "@"
                    : _email;
          }
        } else if (value.description == "Gmail") {
          if (emailPrimaryController.text.contains("@gmail")) {
          } else if (emailPrimaryController.text.contains("@hotmail")) {
            List _emailPCSplit = emailPrimaryController.text.split("@");
            String _email = _emailPCSplit[0];
            emailPrimaryController.text = _email + "@gmail.com";
          } else if (!emailPrimaryController.text.contains("@hotmail") &&
              !emailPrimaryController.text.contains("@gmail")) {
            List _emailPCSplit = emailPrimaryController.text.split("@");
            String _email = _emailPCSplit[0];
            emailPrimaryController.text = _email + "@gmail.com";
          }
        } else if (value.description == "Hotmail") {
          if (emailPrimaryController.text.contains("@gmail")) {
            List _emailPCSplit = emailPrimaryController.text.split("@");
            String _email = _emailPCSplit[0];
            emailPrimaryController.text = _email + "@hotmail.com";
          } else if (!emailPrimaryController.text.contains("@hotmail") &&
              !emailPrimaryController.text.contains("@gmail")) {
            List _emailPCSplit = emailPrimaryController.text.split("@");
            String _email = _emailPCSplit[0];
            emailPrimaryController.text = _email + "@hotmail.com";
          }
        }
        emailPrimaryNode.requestFocus();
      }
    });
  }

  void _selectCboDomainSecondary({required BuildContext contextSnack, required Generic value}) {
    setState(() {
      _domainSecondaryText = value.description ?? '';
      if (value.description == "Otro") {
        if (emailSecondaryController.text.contains("@gmail")) {
          List _emailPCSplit = emailSecondaryController.text.split("@");
          String _email = _emailPCSplit[0];
          emailSecondaryController.text =
              (emailSecondaryController.text.contains("@"))
                  ? _email + "@"
                  : _email;
        } else if (emailSecondaryController.text.contains("@hotmail")) {
          List _emailPCSplit = emailSecondaryController.text.split("@");
          String _email = _emailPCSplit[0];
          emailSecondaryController.text =
              (emailSecondaryController.text.contains("@"))
                  ? _email + "@"
                  : _email;
        }
      } else if (value.description == "Gmail") {
        if (emailSecondaryController.text.contains("@gmail")) {
        } else if (emailSecondaryController.text.contains("@hotmail")) {
          List _emailPCSplit = emailSecondaryController.text.split("@");
          String _email = _emailPCSplit[0];
          emailSecondaryController.text = _email + "@gmail.com";
        } else if (!emailSecondaryController.text.contains("@hotmail") &&
            !emailSecondaryController.text.contains("@gmail")) {
          List _emailPCSplit = emailSecondaryController.text.split("@");
          String _email = _emailPCSplit[0];
          emailSecondaryController.text = _email + "@gmail.com";
        }
      } else if (value.description == "Hotmail") {
        if (emailSecondaryController.text.contains("@gmail")) {
          List _emailPCSplit = emailSecondaryController.text.split("@");
          String _email = _emailPCSplit[0];
          emailSecondaryController.text = _email + "@hotmail.com";
        } else if (!emailSecondaryController.text.contains("@hotmail") &&
            !emailSecondaryController.text.contains("@gmail")) {
          List _emailPCSplit = emailSecondaryController.text.split("@");
          String _email = _emailPCSplit[0];
          emailSecondaryController.text = _email + "@hotmail.com";
        }
      }
      emailSecondaryNode.requestFocus();
    });
  }

  void _selectCboDomainOperator({required BuildContext contextSnack, required Generic value}) {
    setState(() {
      _domainOperatorText = value.description ?? '';
      if (_domainOperatorText == "" ||
          _domainOperatorText == null ||
          _domainOperatorText == "Seleccione dominio") {
        CustomSnackbar.snackBar(
            contextSnack: contextSnack,
            isError: true,
            message: "Seleccione dominio");
      } else {
        if (value.description == "Otro") {
          if (emailOperatorController.text.contains("@gmail")) {
            List _emailPCSplit = emailOperatorController.text.split("@");
            String _email = _emailPCSplit[0];
            emailOperatorController.text =
                (emailOperatorController.text.contains("@"))
                    ? _email + "@"
                    : _email;
          } else if (emailOperatorController.text.contains("@hotmail")) {
            List _emailPCSplit = emailOperatorController.text.split("@");
            String _email = _emailPCSplit[0];
            emailOperatorController.text =
                (emailOperatorController.text.contains("@"))
                    ? _email + "@"
                    : _email;
          }
        } else if (value.description == "Gmail") {
          if (emailOperatorController.text.contains("@gmail")) {
          } else if (emailOperatorController.text.contains("@hotmail")) {
            List _emailPCSplit = emailOperatorController.text.split("@");
            String _email = _emailPCSplit[0];
            emailOperatorController.text = _email + "@gmail.com";
          } else if (!emailOperatorController.text.contains("@hotmail") &&
              !emailOperatorController.text.contains("@gmail")) {
            List _emailPCSplit = emailOperatorController.text.split("@");
            String _email = _emailPCSplit[0];
            emailOperatorController.text = _email + "@gmail.com";
          }
        } else if (value.description == "Hotmail") {
          if (emailOperatorController.text.contains("@gmail")) {
            List _emailPCSplit = emailOperatorController.text.split("@");
            String _email = _emailPCSplit[0];
            emailOperatorController.text = _email + "@hotmail.com";
          } else if (!emailOperatorController.text.contains("@hotmail") &&
              !emailOperatorController.text.contains("@gmail")) {
            List _emailPCSplit = emailOperatorController.text.split("@");
            String _email = _emailPCSplit[0];
            emailOperatorController.text = _email + "@hotmail.com";
          }
        }
        emailOperatorNode.requestFocus();
      }
    });
  }

  void _changeValueIsTitular({required int value}) {
    setState(() {
      isTitular = (value == 1) ? true : false;
      if (value == 1) {
        _domainPrimaryIsError = false;
      } else {
        _domainOperatorIsError = false;
      }
    });
  }

  Future<Null> getSharedPrefs() async {
    setState(() {
      final pref = WService.visitPref;
      if (pref != null &&
          pref.esTitular != null &&
          pref.esTitular!.isNotEmpty) {
        isTitular = pref.esTitular! == "Si";
        if (isTitular) {
          group = 1;
        } else {
          group = 2;
        }

        emailPrimaryController.text =
            pref.correoElectronico ?? emailPrimaryController.text;
        emailSecondaryController.text =
            pref.correoElectronico2 ?? emailSecondaryController.text;
        emailOperatorController.text =
            pref.correoElectronicoOperador ?? emailOperatorController.text;

        if (pref.correoElectronico != null &&
            pref.correoElectronico!.contains("gmail")) {
          _selectCboDomainPrimary(contextSnack: context, value: domainGmail);
        } else if (pref.correoElectronico != null &&
            pref.correoElectronico!.contains("hotmail")) {
          _selectCboDomainPrimary(contextSnack: context, value: domainHotmail);
        } else if (pref.correoElectronico != null) {
          _selectCboDomainPrimary(contextSnack: context, value: domainOther);
        }

        if (pref.correoElectronico2 != null &&
            pref.correoElectronico2!.contains("gmail")) {
          _selectCboDomainSecondary(contextSnack: context, value: domainGmail);
        } else if (pref.correoElectronico2 != null &&
            pref.correoElectronico2!.contains("hotmail")) {
          _selectCboDomainSecondary(
              contextSnack: context, value: domainHotmail);
        } else if (pref.correoElectronico2 != null &&
            pref.correoElectronico2 != "") {
          _selectCboDomainSecondary(contextSnack: context, value: domainOther);
        }

        if (pref.correoElectronicoOperador != null &&
            pref.correoElectronicoOperador!.contains("gmail")) {
          _selectCboDomainOperator(contextSnack: context, value: domainGmail);
        } else if (pref.correoElectronicoOperador != null &&
            pref.correoElectronicoOperador!.contains("hotmail")) {
          _selectCboDomainOperator(contextSnack: context, value: domainHotmail);
        } else if (pref.correoElectronicoOperador != null &&
            pref.correoElectronicoOperador != "") {
          _selectCboDomainOperator(contextSnack: context, value: domainOther);
        }

        isPhonePrimary = pref.tipoTelefono == "Fijo";
        isPhoneSecondary = pref.tipoTelefonoContacto2 == "Fijo";
        if (isPhonePrimary && pref.telefono != null) {
          phonePrimaryController.text = pref.telefono!
              .substring(3, pref.telefono!.length);
          codCityPrimaryController.text =
              pref.telefono!.substring(0, 3);
        } else if (pref.telefono != null) {
          cellPhonePrimaryController.text = pref.telefono!;
        }
        if (isPhoneSecondary && pref.telefonoContacto2 != null) {
          phoneSecondaryController.text = pref.telefonoContacto2!
              .substring(3, pref.telefonoContacto2!.length);
          codCitySecondaryController.text =
              pref.telefonoContacto2!.substring(0, 3);
        } else if (pref.telefonoContacto2 != null) {
          cellPhoneSecondaryController.text =
              pref.telefonoContacto2!;
        }
        if (pref.celularOperador != null)
          cellPhoneOperatorController.text = pref.celularOperador!;
        if (pref.nombreOperador != null)
          nameOperatorController.text = pref.nombreOperador!;
      }
    });
    emailPrimaryNode.requestFocus();
    Future.delayed(Duration(milliseconds: 200), () => setScroll());
  }

  saveData() {
    _domainPrimaryIsError =
        (_domainPrimaryText == "" && isTitular) ? true : false;
    _domainOperatorIsError =
        (_domainOperatorText == "" && !isTitular) ? true : false;
    String _isTitular = (isTitular) ? "Si" : "No";
    String? _emailPrimary = (isTitular) ? emailPrimaryController.text : null;
    String? _emailSecondary = (isTitular) ? emailSecondaryController.text : null;
    String? _emailOperator = (isTitular) ? null : emailOperatorController.text;
    String _typePhonePrmiary = (isPhonePrimary) ? "Fijo" : "Celular";
    String _phonePrimary = (isPhonePrimary)
        ? codCityPrimaryController.text + phonePrimaryController.text
        : cellPhonePrimaryController.text;
    String _typePhoneSecondary = (isPhoneSecondary) ? "Fijo" : "Celular";
    String _phoneSecondary = (isPhoneSecondary)
        ? codCitySecondaryController.text + phoneSecondaryController.text
        : cellPhoneSecondaryController.text;
    String? _cellPhoneOperator =
        (!isTitular) ? cellPhoneOperatorController.text : null;
    String? _nameOperator = (!isTitular) ? nameOperatorController.text : null;
    WService.visitPref = new Visit();
    WService.visitPref!.esTitular = _isTitular;
    WService.visitPref!.correoElectronico = _emailPrimary;
    WService.visitPref!.correoElectronico2 = _emailSecondary;
    WService.visitPref!.correoElectronicoOperador = _emailOperator;
    WService.visitPref!.tipoTelefono = _typePhonePrmiary;
    WService.visitPref!.telefono = _phonePrimary;
    WService.visitPref!.tipoTelefonoContacto2 = _typePhoneSecondary;
    WService.visitPref!.telefonoContacto2 = _phoneSecondary;
    WService.visitPref!.celularOperador = _cellPhoneOperator;
    WService.visitPref!.nombreOperador = _nameOperator;
    WService.visitPref!.nombreComercio = store;
    WService.visitPref!.nombreTitular = contact;
    return true;
  }

  void _validateForm(BuildContext contextSnack) {
    final form = _formKey.currentState;
    setState(() {
      _domainPrimaryIsError =
          (_domainPrimaryText == "" && isTitular) ? true : false;
      _domainOperatorIsError =
          (_domainOperatorText == "" && !isTitular) ? true : false;

      _errorMailPrimary = (emailPrimaryController.text == "" ||
              !validateEmail(emailPrimaryController.text))
          ? true
          : false;

      _errorPhone = (isPhonePrimary)
          ? (codCityPrimaryController.text + phonePrimaryController.text)
                  .length <
              9
          : false;

      String fullPhone =
          codCitySecondaryController.text + phoneSecondaryController.text;
      _errorPhone = (isPhoneSecondary && fullPhone.length > 0)
          ? (codCitySecondaryController.text + phoneSecondaryController.text)
                  .length <
              9
          : false;
    });
    if (form?.validate() == true &&
        !_domainPrimaryIsError &&
        !_domainOperatorIsError &&
        !_errorPhone) {
      String _isTitular = (isTitular) ? "Si" : "No";
      String? _emailPrimary = (isTitular) ? emailPrimaryController.text : null;
      String? _emailSecondary =
          (isTitular) ? emailSecondaryController.text : null;
      String? _emailOperator = (isTitular) ? null : emailOperatorController.text;
      String _typePhonePrmiary = (isPhonePrimary) ? "Fijo" : "Celular";
      String _phonePrimary = (isPhonePrimary)
          ? codCityPrimaryController.text + phonePrimaryController.text
          : cellPhonePrimaryController.text;
      String _typePhoneSecondary = (isPhoneSecondary) ? "Fijo" : "Celular";
      String _phoneSecondary = (isPhoneSecondary)
          ? codCitySecondaryController.text + phoneSecondaryController.text
          : cellPhoneSecondaryController.text;
      String? _cellPhoneOperator =
          (!isTitular) ? cellPhoneOperatorController.text : null;
      String? _nameOperator = (!isTitular) ? nameOperatorController.text : null;

      visitReceived.esTitular = _isTitular;
      visitReceived.correoElectronico = _emailPrimary;
      visitReceived.correoElectronico2 = _emailSecondary;
      visitReceived.correoElectronicoOperador = _emailOperator;
      visitReceived.tipoTelefono = _typePhonePrmiary;
      visitReceived.telefono = _phonePrimary;
      visitReceived.tipoTelefonoContacto2 = _typePhoneSecondary;
      visitReceived.telefonoContacto2 = _phoneSecondary;
      visitReceived.celularOperador = _cellPhoneOperator;
      visitReceived.nombreOperador = (!isTitular) ? _nameOperator : contact;
      visitReceived.nombreComercio = store;
      visitReceived.nombreTitular = contact;
      visitReceived.latitud = data.latitud;
      visitReceived.longitud = data.longitud;
      visitReceived.estado = 3;
      visitReceived.fechaInstalacion = data.estado?.fecha;
      BlocProvider.of<VisitBloc>(context)
          .add(UpdateVisitEvent(visit: visitReceived));
    } else {
      if (isPhonePrimary &&
          (!codCityPrimaryController.text.startsWith("0", 0) ||
              codCityPrimaryController.text.endsWith("0"))) {
        CustomSnackbar.snackBar(
            contextSnack: contextSnack,
            isError: true,
            message: "Codigo telefonico invalido");
      } else if (isPhoneSecondary &&
          (!codCitySecondaryController.text.startsWith("0", 0) ||
              codCitySecondaryController.text.endsWith("0"))) {
        CustomSnackbar.snackBar(
            contextSnack: contextSnack,
            isError: true,
            message: "Codigo telefonico invalido");
      } else if (_errorPhone) {
        CustomSnackbar.snackBar(
            contextSnack: contextSnack,
            isError: true,
            message: "Verifique la longitud del numero telefonico");
      } else {
        CustomSnackbar.snackBar(
            contextSnack: contextSnack,
            isError: true,
            message: "Es necesario el ingreso de todos los campos");
      }
    }
  }

  Widget _loading(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        (state is LoadingVisitState)
            ? isLoadingVisit = true
            : isLoadingVisit = false;
        if (state is UpdateVisitState) {
          if (WService.stateAgent == 2) {
            if (!isTitular) {
              visitReceived.correoElectronico = data.correoElectronico;
              visitReceived.correoElectronico2 = data.correoElectronico2;
            }
            BlocProvider.of<AgentBloc>(context)
                .add(UpdateAgentEvent(visit: visitReceived, agent: data));
          } else {
            Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
            Navigator.pushNamed(context, InformationAgentSecondaryViewRoute,
                arguments: obj);
          }
        }

        if (state is GetLocationState) {
          setState(() {
            if (state.agentData != null) {
              data = state.agentData;
              address = state.agentData.direccion ?? '';
              contact = state.agentData.nombreTitular ?? '';
              store = state.agentData.nombreComercio ?? '';
              if (state.agentData.esTitular == null ||
                  state.agentData.esTitular?.toLowerCase() == "si") {
                isTitular = true;
              } else {
                isTitular = false;
              }
              if (isTitular) {
                emailPrimaryController.text = state.agentData.correoElectronico ?? '';
                emailSecondaryController.text =
                    state.agentData.correoElectronico2 ?? '';
                group = 1;
                if (state.agentData.tipoTelefono != null &&
                    (state.agentData.tipoTelefono!.toLowerCase() == "fijo" ||
                        state.agentData.telefono!.startsWith("0", 0))) {
                  isPhonePrimary = true;
                } else {
                  isPhonePrimary = false;
                }
                if (state.agentData.tipoTelefonoContacto2 != null &&
                    (state.agentData.tipoTelefonoContacto2!.toLowerCase() ==
                            "fijo" ||
                        state.agentData.telefonoContacto2!.startsWith("0", 0))) {
                  isPhoneSecondary = true;
                } else {
                  isPhoneSecondary = false;
                }

                if (isPhonePrimary) {
                  if (state.agentData.telefono != null) {
                    state.agentData.telefono = state.agentData.telefono!
                        .trim()
                        .replaceAll("-", "")
                        .replaceAll(" ", "");
                  }
                  if (state.agentData.telefono != null &&
                      state.agentData.telefono!.length > 3) {
                    if (state.agentData.telefono!.length < 9) {
                      // si hay 9 se divide 6 y 3 y si tiene 7 divido 2 y 7
                      phonePrimaryController.text = state.agentData.telefono!
                          .padLeft(9, "0")
                          .substring(3, 9);
                      codCityPrimaryController.text = state.agentData.telefono!
                          .padLeft(9, "0")
                          .substring(0, 3);
                    } else {
                      phonePrimaryController.text =
                          state.agentData.telefono!.substring(3, 9);
                      codCityPrimaryController.text =
                          state.agentData.telefono!.substring(0, 3);
                    }
                  }
                } else {
                  if (state.agentData.telefono != null)
                    cellPhonePrimaryController.text =
                        state.agentData.telefono!.trim();
                }
                if (isPhoneSecondary) {
                  if (state.agentData.telefonoContacto2 != null) {
                    state.agentData.telefonoContacto2 = state
                        .agentData.telefonoContacto2!
                        .trim()
                        .replaceAll("-", "")
                        .replaceAll(" ", "");
                  }

                  if (state.agentData.telefonoContacto2 != null &&
                      state.agentData.telefonoContacto2!.length > 3) {
                    if (state.agentData.telefonoContacto2!.length < 9) {
                      phoneSecondaryController.text = state
                          .agentData.telefonoContacto2!
                          .padLeft(9, "0")
                          .substring(3, 9);
                      codCitySecondaryController.text = state
                          .agentData.telefonoContacto2!
                          .padLeft(9, "0")
                          .substring(0, 3);
                    } else {
                      phoneSecondaryController.text =
                          state.agentData.telefonoContacto2!.substring(3, 9);
                      codCitySecondaryController.text =
                          state.agentData.telefonoContacto2!.substring(0, 3);
                    }
                  }
                } else {
                  if (state.agentData.telefonoContacto2 != null)
                    cellPhoneSecondaryController.text =
                        state.agentData.telefonoContacto2!.trim();
                }

                if (state.agentData.correoElectronico != null &&
                    state.agentData.correoElectronico!
                        .toUpperCase()
                        .contains("GMAIL")) {
                  _selectCboDomainPrimary(
                      contextSnack: context, value: domainHotmail);
                } else if (state.agentData.correoElectronico != null &&
                    state.agentData.correoElectronico!
                        .toUpperCase()
                        .contains("HOTMAIL")) {
                  _selectCboDomainPrimary(
                      contextSnack: context, value: domainGmail);
                } else if (state.agentData.correoElectronico != null) {
                  _selectCboDomainPrimary(
                      contextSnack: context, value: domainOther);
                }

                if (state.agentData.correoElectronico2 != null &&
                    state.agentData.correoElectronico2!
                        .toUpperCase()
                        .contains("GMAIL")) {
                  _selectCboDomainSecondary(
                      contextSnack: context, value: domainHotmail);
                } else if (state.agentData.correoElectronico2 != null &&
                    state.agentData.correoElectronico2!
                        .toUpperCase()
                        .contains("HOTMAIL")) {
                  _selectCboDomainSecondary(
                      contextSnack: context, value: domainGmail);
                } else if (state.agentData.correoElectronico2 != null) {
                  _selectCboDomainSecondary(
                      contextSnack: context, value: domainOther);
                }
              } else {
                emailOperatorController.text =
                    state.agentData.correoElectronico ?? '';
                group = 2;
                isPhonePrimary =
                    state.agentData.tipoTelefono?.toLowerCase() == "fijo";

                if (state.agentData.correoElectronico != null &&
                    state.agentData.correoElectronico!
                        .toUpperCase()
                        .contains("GMAIL")) {
                  _selectCboDomainOperator(
                      contextSnack: context, value: domainGmail);
                } else if (state.agentData.correoElectronico != null &&
                    state.agentData.correoElectronico!
                        .toUpperCase()
                        .contains("HOTMAIL")) {
                  _selectCboDomainOperator(
                      contextSnack: context, value: domainHotmail);
                } else if (state.agentData.correoElectronico != null) {
                  _selectCboDomainOperator(
                      contextSnack: context, value: domainOther);
                }
              }
            }
          });
          getSharedPrefs();
          emailPrimaryNode.requestFocus();
          Future.delayed(Duration(milliseconds: 500), () => setScroll());
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
              message: "Seleccione almenos un día");
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

  void setScroll() {
    if (scrollController != null) {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  dynamic validatenNumber(value) {
    String pattern = r'^[0][1-9]{8}$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  dynamic validateEmail(value) {
    String pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
    RegExp regExp = new RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}
