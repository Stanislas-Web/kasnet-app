import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart'
    as confirm;
import 'package:un/common/dialogs/custom_dialog_info.dart';
import 'package:un/common/inputs/custom_comentario.dart';
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ComentaryView extends StatelessWidget {
  final bool isDown;
  final Visit visitReceived;

  const ComentaryView({Key? key, required this.visitReceived, required this.isDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<VisitBloc>(
          create: (_) => VisitBloc(visitLogic: SimpleVisit())),
    ], child: ComentarySFull(visitReceived: visitReceived, isDown: isDown));
  }
}

class ComentarySFull extends StatefulWidget {
  final bool isDown;
  final Visit visitReceived;

  const ComentarySFull({Key? key, required this.visitReceived, required this.isDown})
      : super(key: key);

  @override
  _ComentaryState createState() =>
      _ComentaryState(visitReceived: visitReceived);
}

class _ComentaryState extends State<ComentarySFull> {
  final Visit visitReceived;
  bool isTitular = false;

  final comentaryController = TextEditingController();
  final FocusNode comentaryNode = FocusNode();
  late BuildContext contextLB;
  bool _isLoading = false;

  var _scaffoldKey;
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    if (WService.comentaryPref.isNotEmpty) {
      setState(() {
        comentaryController.text = WService.comentaryPref;
      });
    }
  }

  @override
  void dispose() {
    if (comentaryController.text.isNotEmpty) {
      WService.comentaryPref = comentaryController.text;
    }
    comentaryController.dispose();
    comentaryNode.dispose();
    super.dispose();
  }

  _ComentaryState({required this.visitReceived});

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.vertical > 0;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: PrimaryThemeColor,
        title: Text("Comentario Visita"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.input),
              onPressed: () async {
                final action = await confirm.CustomDialogConfirm.yesAbortDialog(
                    context, "", "¿Desea cerrar sesión?");
                if (action == confirm.DialogAction.yes) {
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
            return Container(
              width: screenWidth,
              height: screenHeight,
              color: PrimaryThemeColor,
              child: _body(screenHeight, screenWidth, context),
            );
          }),
          _loading(screenHeight, screenWidth, contextLB),
          Logo(isKeyboard: isKeyboard),
        ],
      ),
    );
  }

  Widget _body(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: screenWidth - 50,
                height: screenHeight - 300,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 5, color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Text(
                              "Ingrese algún comentario en relación a la visita del agente",
                              style: TextStyle(
                                  color: PrimaryThemeColor, fontSize: 17.5),
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        CustomInputComentario(
                          isRequired: true,
                          inputTypeInfo: "",
                          borderColor: PrimaryThemeColor,
                          hintText: "Ingrese comentario",
                          width: screenWidth * 1.2,
                          height: 150,
                          heightFont: 18,
                          inputType: TextInputType.text,
                          isLastInput: true,
                          focus: false,
                          controller: comentaryController,
                          currentNode: comentaryNode,
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),
        _btnNextStep(screenWidth, contextSnack),
        SizedBox(height: 0)
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
        width: screenWidth * 0.33,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Finalizar",
                style: TextStyle(
                    color: PrimaryThemeColor, fontSize: screenWidth * 0.045)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () async {
        /* if (comentaryController.text.length <= 0) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Ingresar comentario");
        } else {*/
        visitReceived.estado = 7;
        visitReceived.comentario = comentaryController.text;
        BlocProvider.of<VisitBloc>(context)
            .add(UpdateVisitEvent(visit: visitReceived));
        // }
      },
    );
  }

  Widget _loading(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) async {
        if (state is UpdateVisitState) {
          _isLoading = false;
          final action = await CustomDialogInfo.infoDialog(
              context, "La visita se ha guardado con éxito!", "");
          if (action != null) {
            WService.clearPref();
            Navigator.of(context).pushNamedAndRemoveUntil(
                VisitAgentRoute, (Route<dynamic> route) => false);
          }
        }
        if (state is LoadingVisitState) {
          (state is LoadingVisitState) ? _isLoading = true : _isLoading = false;
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
              message: "Seleccione almenos una respuesta");
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
}
