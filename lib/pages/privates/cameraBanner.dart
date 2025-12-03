import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/logics/logic.dart';
import 'package:un/models/get_photos.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:un/logics/logic_visit.dart';
import '../../blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';

class RegisterPhotoBannerView extends StatelessWidget {
  final bool isDown;
  final Visit visitReceived;

  const RegisterPhotoBannerView({Key? key, required this.visitReceived, required this.isDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VisitBloc>(
              create: (_) => VisitBloc(visitLogic: SimpleVisit()))
        ],
        child: RegisterPhotoBannerSFull(
            visitReceived: visitReceived, isDown: isDown));
  }
}

class RegisterPhotoBannerSFull extends StatefulWidget {
  final bool isDown;
  final Visit visitReceived;

  const RegisterPhotoBannerSFull({Key? key, required this.visitReceived, required this.isDown})
      : super(key: key);
  @override
  _RegisterPhotoBannerState createState() =>
      _RegisterPhotoBannerState(visitReceived: visitReceived);
}

class _RegisterPhotoBannerState extends State<RegisterPhotoBannerSFull> {
  final Visit visitReceived;
  final enterpriseController = TextEditingController();
  final FocusNode enterpriseNode = FocusNode();

  double pdRightCustomConteiner = 0;
  bool isSigned = false;
  bool _isLoading = false;
  String isgnedText = "";
  List<String> _imageFile = [];
  late BuildContext contextLB;
  int indexErase = 0;
  static String? saved;
  List<String>? disabled = [];

  var _scaffoldKey;
  late GoogleSignIn _googleSignIn;

  _RegisterPhotoBannerState({required this.visitReceived});

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    saved = WService.acta;
    isgnedText = saved ?? '';
    isSigned = (saved == "Si") ? true : false;
    visitReceived.firmaActaDesinstalacion = isSigned;
    disabled?.add(saved ?? '');
    BlocProvider.of<VisitBloc>(context)
        .add(GetPhotosEvent(id: visitReceived.id!, type: 0));
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.vertical > 0;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    pdRightCustomConteiner =
        (screenHeight <= 600) ? screenHeight - 410 : screenHeight - 500;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: PrimaryThemeColor,
        title: Text("Registro de Foto"),
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
                color: PrimaryThemeColor,
                child: _body(screenHeight, screenWidth, context),
                padding: EdgeInsets.only(top: screenHeight * 0.03));
          }),
          Padding(
            padding: EdgeInsets.only(
                top: (!widget.isDown)
                    ? screenHeight * 0.45 //0.45
                    : screenHeight * 0.50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _btnDeletePhoto(screenWidth, screenHeight),
                _btnTakePhoto(screenWidth, screenHeight, contextLB),
              ],
            ),
          ),
          Logo(isKeyboard: isKeyboard),
          _loadingAddPhoto(screenHeight, screenWidth, contextLB)
        ],
      ),
    );
  }

  Widget _body(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 16.0, right: 16.0, left: 16.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: screenWidth - 50,
                  height: screenHeight * 0.575,
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 0.0, right: 0.0, left: 0.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        (widget.isDown &&
                                visitReceived.estadoAgente?.toLowerCase() !=
                                    "cerrado")
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                    child: Text(
                                        "¿Firmo acta de desinstalación?",
                                        style: LabelBlueNormalInput,
                                        textAlign: TextAlign.start),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Radio<String>(
                                            value: 'Si',
                                            groupValue: saved,
                                            activeColor: PrimaryThemeColor,
                                            onChanged: (disabled?.contains('Si') ?? false) ? null : (value) {
                                              setState(() {
                                                saved = value;
                                                disabled = [];
                                                WService.acta = value;
                                                isgnedText = value ?? '';
                                                isSigned = (value == "Si");
                                                visitReceived.firmaActaDesinstalacion = isSigned;
                                                disabled?.add(value ?? '');
                                              });
                                            },
                                          ),
                                          Text('Si', style: LabelBlueNormalInputText),
                                          SizedBox(width: 20),
                                          Radio<String>(
                                            value: 'No',
                                            groupValue: saved,
                                            activeColor: PrimaryThemeColor,
                                            onChanged: (disabled?.contains('No') ?? false) ? null : (value) {
                                              setState(() {
                                                saved = value;
                                                disabled = [];
                                                WService.acta = value;
                                                isgnedText = value ?? '';
                                                isSigned = (value == "Si");
                                                visitReceived.firmaActaDesinstalacion = isSigned;
                                                disabled?.add(value ?? '');
                                              });
                                            },
                                          ),
                                          Text('No', style: LabelBlueNormalInputText),
                                        ],
                                      ))
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: (widget.isDown &&
                                      visitReceived.estadoAgente
                                              ?.toLowerCase() !=
                                          "cerrado")
                                  ? const EdgeInsets.all(0)
                                  : const EdgeInsets.all(30),
                              child: Text("Toma una foto de la fachada",
                                  style: LabelBlueNormalInput,
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: _buildImage(screenWidth, screenHeight),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _btnNextStep(screenWidth, screenHeight, contextSnack),
              ],
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }

  Widget _btnTakePhoto(double screenWidth, double screenHeight, context) {
    return InkWell(
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Icon(Icons.camera_alt, color: PrimaryThemeColor)),
      onTap: () => captureImage(context),
    );
  }

  Widget _btnNextStep(
      double screenWidth, double screenHeight, BuildContext contextSnack) {
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
                (widget.isDown ||
                        visitReceived.estadoAgente?.toLowerCase() == "cerrado")
                    ? "Comentar Visita"
                    : "Tomar foto voucher",
                style: TextStyle(
                    color: PrimaryThemeColor, fontSize: screenWidth * 0.045)),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () {
        if ((isgnedText == "" || isgnedText.isEmpty) &&
            widget.isDown &&
            visitReceived.estadoAgente?.toLowerCase() != "cerrado") {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Indique si realizó la firma");
        } else if (_imageFile.length == 0) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Tomar la foto de la fachada");
        } else {
          BlocProvider.of<VisitBloc>(context)
              .add(DeletePhotosEvent(id: visitReceived.id!, type: 0));
        }
      },
    );
  }

  Widget _btnDeletePhoto(double screenWidth, double screenHeight) {
    return InkWell(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Icon(
          Icons.delete,
          color: PrimaryThemeColor,
        ),
      ),
      onTap: () async {
        setState(() {
          if (_imageFile.length > 0 && indexErase <= _imageFile.length) {
            _imageFile.removeAt(indexErase);
          }
        });
      },
    );
  }

  Widget _loadingAddPhoto(
      double screenHeight, double screenWidth, BuildContext contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        if (state is UpdateVisitState) {
          _isLoading = false;
          Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
          Navigator.pushNamed(
            context,
            ComentaryViewRoute,
            arguments: obj,
          );
        }

        if (state is AddPhotoState) {
          _isLoading = false;
          if (_imageFile.length > 1 && WService.fotoFachada <= 1) {
            BlocProvider.of<VisitBloc>(context).add(AddPhototEvent(
                fileData: _imageFile.last, id: visitReceived.id!, type: 0));
          } else {
            Map obj = {'visit': visitReceived, 'stateStore': widget.isDown};
            if (widget.isDown) {
              if (visitReceived.estadoAgente?.toLowerCase() != "cerrado") {
                visitReceived.estado = 6;
                BlocProvider.of<VisitBloc>(context)
                    .add(UpdateVisitEvent(visit: visitReceived));
              } else {
                WService.fotoFachada = 0;
                Navigator.pushNamed(
                  context,
                  ComentaryViewRoute,
                  arguments: obj,
                );
              }
            } else {
              if (visitReceived.estadoAgente?.toLowerCase() != "cerrado") {
                WService.fotoFachada = 0;
                Navigator.pushNamed(
                  context,
                  RegisterPhotoVoucherViewRoute,
                  arguments: obj,
                );
              } else {
                WService.fotoFachada = 0;
                Navigator.pushNamed(
                  context,
                  ComentaryViewRoute,
                  arguments: obj,
                );
              }
            }
          }
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
          _isLoading = false;
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "No se pudo actualizar la data");
        }
        if (state is LoadingVisitState) {
          (state is LoadingVisitState) ? _isLoading = true : _isLoading = false;
        }
        if (state is GetPhotoState) {
          _isLoading = false;
          if (state.photos != null) {
            for (GetPhotosResponse photo in state.photos) {
              setState(() {
                _imageFile.add(photo.imagen ?? '');
              });
            }
          }
        }
        if (state is DeletePhotoState) {
          BlocProvider.of<VisitBloc>(context).add(AddPhototEvent(
              fileData: _imageFile.first, id: visitReceived.id!, type: 0));
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

  Widget _buildImage(screenWidth, screenHeight) {
    if (_imageFile.length > 0) {
      return Container(
          height: screenHeight * .37,
          child: CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      indexErase = index;
                    });
                  }),
              items: _imageFile
                  .map((item) => Container(
                        child: Center(
                            child: Image.memory(
                          Base64Decoder().convert(item),
                          fit: BoxFit.fill,
                          height: 250,
                          width: 300,
                        )),
                      ))
                  .toList()));
    } else {
      return _placeholderImage();
    }
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.black45,
      height: 250,
      width: 300,
      child: Padding(
        padding: EdgeInsets.only(top: 115),
        child: Text(
          '300 X 250',
          style: TextStyle(fontSize: 19.0),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Future<void> captureImage(contextSnack) async {
    if (_imageFile.length >= 2) {
      CustomSnackbar.snackBar(
          contextSnack: contextSnack,
          isError: true,
          message:
              "Elimine una foto para poder tomar otra. Se pueden tomar como máximo 2 fotos.");
      return;
    }
    try {
      setState(() {
        //_isLoading = true;
      });

      final file = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraCamera(
                    onFile: (file) {
                      Navigator.pop(context, file);
                    },
                  )));
      if (file != null) {
        final decoded = decode(file);
        if (decoded != null) {
          _imageFile.add(decoded);
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  String? decode(File? file) {
    if (file == null) {
      return null;
    }
    return base64Encode(file.readAsBytesSync());
  }
}
