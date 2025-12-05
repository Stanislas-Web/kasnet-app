import 'dart:async';
import 'package:un/blocs/bloc/agent_bloc/agent_bloc.dart';
import 'package:un/blocs/bloc/visit_bloc/visit_bloc.dart';
import 'package:un/common/custom_loading.dart';
import 'package:un/common/custom_logo.dart';
import 'package:un/common/custom_snackbar.dart';
import 'package:un/common/dialogs/custom_dialog_confirm.dart';
import 'package:un/common/dialogs/custom_dialog_info.dart' as _info;
import 'package:un/logics/logic.dart';
import 'package:un/logics/logic_agent.dart';
import 'package:un/logics/logic_visit.dart';
import 'package:un/logics/string_capital.dart';
import 'package:un/models/find_agent.dart';
import 'package:un/models/visit.dart';
import 'package:un/routes/routing_constants.dart';
import 'package:un/styles/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart' as _location;
import 'dart:math' show cos, sqrt, asin;

class LocationAgentView extends StatelessWidget {
  final bool isDown;
  final Visit visitReceived;

  const LocationAgentView({Key? key, required this.isDown, required this.visitReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<VisitBloc>(
              create: (_) => VisitBloc(visitLogic: SimpleVisit())),
          BlocProvider<AgentBloc>(
            create: (_) => AgentBloc(agentLogic: SimpleAgent()),
          )
        ],
        child:
            LocationAgentViewSF(isDown: isDown, visitReceived: visitReceived));
  }
}

class LocationAgentViewSF extends StatefulWidget {
  final Visit visitReceived;
  final bool isDown;

  const LocationAgentViewSF({Key? key, required this.visitReceived, required this.isDown})
      : super(key: key);
  @override
  _MapState createState() => _MapState(
        visitReceived: visitReceived,
        isDown: isDown,
      );
}

class _MapState extends State<LocationAgentViewSF> {
  late FindAgentResponse agentData;
  bool editPos = false;
  late LatLng currentlocation;
  late LatLng updateLocation;
  String address = "";
  String latitud = "";
  String longitud = "";
  var location = _location.Location();
  final bool isDown;
  final Visit visitReceived;
  Completer<GoogleMapController> controller1 = Completer();
  static LatLng? _initialPosition;
  late Set<Marker> markers;
  late double latiFinal;
  late double longFinal;
  double pdRightCustomListDocument = 0;
  double pdLeftCustomListDocument = 0;
  double pdTopCustomListDocument = 0;
  double pdBottomCustomListDocument = 0;
  double pdContainers = 0;
  double heightCheckbox = 0;
  double widhtBtn = 0;
  double pdVContainerYellow = 0;
  double pdTopFormEmail = 0;
  double pdHListDocuments = 0;
  bool _isLoading = true;
  BuildContext? contextLB;  // Rendre nullable
  late GoogleSignIn _googleSignIn;
  late GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;

  _MapState({required this.isDown, required this.visitReceived});

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize();
    markers = Set.from([]);
    _checkGps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getUserLocation() async {
    Position positionInit = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (positionInit != null) {
      _initialPosition = LatLng(positionInit.latitude, positionInit.longitude);
      _addMarker(_initialPosition!, true, "1", true);
    } else {
      _getUserLocation();
    }
  }

  void _onCameraMove(CameraPosition position) {}

  _onMapCreated(GoogleMapController controller) {
    if (controller != null) {
      setState(() {
        controller1.complete(controller);
        mapController = controller;
      });
    }
  }

  void _checkGps() async {
    if (!await location.serviceEnabled()) {
      var result = await location.requestService();
      if (result) {
        _getUserLocation();
      }
    } else {
      _getUserLocation();
    }
  }

  Widget _address() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Adresse : ",
              style: LabelBlueNormalInputTextStyle, maxLines: 2),
          Flexible(
              child: Text(address,
                  style: new TextStyle(
                      color: PrimaryThemeColor,
                      fontSize: 15.0,
                      fontFamily: DefaultFontFamily),
                  textAlign: TextAlign.start))
        ],
      ),
    );
  }

  Widget _latitud() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Latitude : ", style: LabelBlueNormalInputTextStyle),
          Text(latitud,
              style: new TextStyle(
                  color: PrimaryThemeColor,
                  fontSize: 15.0,
                  fontFamily: DefaultFontFamily),
              textAlign: TextAlign.right)
        ],
      ),
    );
  }

  Widget _longitud() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Longitude : ", style: LabelBlueNormalInputTextStyle),
          Text(longitud,
              style: new TextStyle(
                  color: PrimaryThemeColor,
                  fontSize: 15.0,
                  fontFamily: DefaultFontFamily),
              textAlign: TextAlign.right)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.vertical > 0;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      backgroundColor: PrimaryThemeColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: PrimaryThemeColor,
        title: Text("Localisation de l'agent", style: TextStyle(color: Colors.white)),
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
              child: _initialPosition == null
                  ? Container(
                      child: Center(
                          child: CustomLoading(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth)))
                  : _body(
                      screenHeight:
                          screenHeight - AppBar().preferredSize.height,
                      screenWidth: screenWidth,
                      contextSnack: context),
            );
          }),
          Logo(isKeyboard: isKeyboard),
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return _loading(screenHeight: screenHeight, screenWidth: screenWidth, contextSnack: context);
          }),
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return _verifyUpdateVisit(context);
          }),
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            return _verifyUpdateAgent(context);
          }),
        ],
      ),
    );
  }

  Widget _body(
      {required double screenHeight, required double screenWidth, required BuildContext contextSnack}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              right: 20.0, left: 20.0, top: 20, bottom: 10),
          child: Container(
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 5),
            decoration: BoxDecoration(
                color: DisabledThemeColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                _address(),
                _latitud(),
                _longitud(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: screenHeight * 0.55,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: _googleMap(screenWidth, screenHeight * 0.55),
            ),
          ),
        ),
        SizedBox(height: 15),
        _btnNextStep(screenWidth, screenHeight),
        SizedBox(height: 50)
      ],
    ));
  }

  Widget _googleMap(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CheckboxListTile(
          title: Text("Mettre à jour la localisation de l'agent",
              maxLines: 2,
              style: new TextStyle(
                  color: PrimaryThemeColor,
                  fontSize: 14.0,
                  fontFamily: DefaultFontFamily)),
          value: editPos,
          onChanged: (WService.stateAgent == 2)
              ? (bool? newValue) async {
                  if (newValue == true) {
                    if (newValue == true) {
                      setState(() {
                        editPos = newValue!;
                        if (currentlocation != null) {
                          _addMarker(currentlocation, false, "2", true);
                        }
                      });
                    }
                  } else {
                    setState(() {
                      editPos = newValue!;
                      resetLocation();
                      if (currentlocation != null) {
                        _addMarker(currentlocation, false, "2", true);
                      }
                    });
                  }
                  WService.editLocation = editPos;
                }
              : null,
          controlAffinity:
              ListTileControlAffinity.trailing, //  <-- leading Checkbox
        ),
        Container(
          width: screenWidth,
          height: screenHeight - 108, //screenHeight * .695,
          padding: EdgeInsets.only(left: 15.0, right: 22.0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                heightFactor: 0.3,
                widthFactor: 2.5,
                child: GoogleMap(
                  markers: Set<Marker>.of(markers),
                  mapToolbarEnabled: false,
                  onTap: (pos) async {
                    if (editPos) {
                      updateHeader(pos);
                      _addMarker(pos, false, "2", true);
                    }
                  },
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition ?? LatLng(0, 0),
                    zoom: 17,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: false,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                )),
          ),
        ),
        _mapButtom(screenHeight - 50),
      ],
    );
  }

  Widget mapButton(VoidCallback function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  Widget _mapButtom(double screenWidth) {
    if (editPos && _initialPosition != null) {
      return Container(
          child: GestureDetector(
        onTap: () {
          mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: _initialPosition!,
            zoom: 25,
          )));
          LatLng pos =
              new LatLng(_initialPosition!.latitude, _initialPosition!.longitude);
          updateLocation = pos;
          updateHeader(pos);
          _addMarker(pos, false, "2", false);
        },
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            width: screenWidth,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new IconButton(
                    icon: Icon(
                      Icons.gps_fixed,
                      color: PrimaryThemeColor,
                    ),
                    onPressed: () {
                      if (_initialPosition != null) {
                        mapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: _initialPosition!,
                          zoom: 25,
                        )));
                        LatLng pos = new LatLng(_initialPosition!.latitude,
                            _initialPosition!.longitude);
                        updateLocation = pos;
                        updateHeader(pos);
                        _addMarker(pos, false, "2", false);
                      }
                    }),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text("Localisation actuelle",
                        style: LabelBlueNormalInputTextStyle,
                        textAlign: TextAlign.center))
              ],
            ),
          ),
        ),
      ));
    } else {
      return Container();
    }
  }

  Widget _btnNextStep(double screenWidth, double screenHeight) {
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
            Text("Prendre photo du magasin",
                style: TextStyle(
                    color: PrimaryThemeColor, fontSize: screenWidth * 0.050)),
            Icon(Icons.arrow_forward_ios, color: PrimaryThemeColor)
          ],
        ),
      ),
      onPressed: () async {
        visitReceived.fechaInstalacion = agentData.estado?.fecha;
        visitReceived.nombreComercio = agentData.nombreComercio;
        if (WService.stateAgent != 2) {
          visitReceived.latitud = agentData.latitud;
          visitReceived.longitud = agentData.longitud;
          visitReceived.estado = 5;
          BlocProvider.of<VisitBloc>(context)
              .add(UpdateVisitEvent(visit: visitReceived));
        } else {
          if (currentlocation == null && updateLocation == null) {
            _info.CustomDialogInfo.infoDialog(
                context, "", "La mise à jour de l'agent est nécessaire");
            return;
          }

          if (updateLocation == null && currentlocation != null) {
            final action = await CustomDialogConfirm.yesAbortDialog(context, "",
                "Êtes-vous sûr de continuer la visite sans mettre à jour la localisation ?");
            if (action == DialogAction.yes) {
              visitReceived.latitud = agentData.latitud;
              visitReceived.longitud = agentData.longitud;
              visitReceived.estado = 5;
              BlocProvider.of<VisitBloc>(context)
                  .add(UpdateVisitEvent(visit: visitReceived));
            }
          } else {
            final action = await CustomDialogConfirm.yesAbortDialog(context, "",
                "Êtes-vous sûr de mettre à jour le magasin avec la localisation indiquée ?");
            if (action == DialogAction.yes) {
              if (agentData != null && updateLocation != null) {
                agentData.latitud = updateLocation.latitude.toString();
                agentData.longitud = updateLocation.longitude.toString();
                visitReceived.latitud = updateLocation.latitude.toString();
                visitReceived.longitud = updateLocation.longitude.toString();
              }
              WService.location = updateLocation;
              visitReceived.correoElectronico = agentData.correoElectronico;
              visitReceived.correoElectronico2 = agentData.correoElectronico2;
              BlocProvider.of<VisitBloc>(context)
                  .add(UpdateVisitEvent(visit: visitReceived));
              /* BlocProvider.of<AgentBloc>(context).add(
                  UpdateAgentEvent(visit: visitReceived, agent: agentData));*/
            }
          }
        }
      },
    );
  }

  Widget _loading(
      {required double screenHeight, required double screenWidth, required BuildContext contextSnack}) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        if (state is LoadingVisitState) {
          _isLoading = true;
        } else {
          _isLoading = false;
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
          CustomSnackbar.snackBar(
              contextSnack: context,
              isError: true,
              message: "Impossible d'obtenir les données de l'agent");
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(builder: (context, state) {
        return (_isLoading)
            ? CustomLoading(
                screenHeight: screenHeight, screenWidth: screenWidth)
            : Container();
      }),
    );
  }

  Widget _verifyUpdateAgent(BuildContext contextSnack) {
    return BlocListener<AgentBloc, AgentState>(
      listener: (context, state) {
        if (state is LoadingGetAgentState) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is UpdateAgentState) {
          visitReceived.estado = 5;
          BlocProvider.of<VisitBloc>(context)
              .add(UpdateVisitEvent(visit: visitReceived));
        }

        if (state is ErrorInAgentState) {
          CustomSnackbar.snackBar(
              contextSnack: contextSnack,
              isError: true,
              message: "Impossible de mettre à jour les données");
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
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }

  Widget _verifyUpdateVisit(BuildContext contextSnack) {
    return BlocListener<VisitBloc, VisitBlocState>(
      listener: (context, state) {
        if (state is LoadingVisitState) {
          _isLoading = true;
        } else {
          _isLoading = false;
        }

        if (state is GetLocationState) {
          setState(() {
            agentData = state.agentData;
            if (state.agentData.direccion != null)
              address = capitalizeAll(state.agentData.direccion!
                  .toLowerCase()); //-12.1246559, //latitud-76.9939536, //longitud
            if (state.agentData.latitud != null &&
                state.agentData.longitud != null &&
                state.agentData.latitud != "-12.124656" &&
                state.agentData.longitud != "-76.99395") {
              LatLng pos = new LatLng(double.parse(state.agentData.latitud!),
                  double.parse(state.agentData.longitud!));
              currentlocation = pos;
              latitud = state.agentData.latitud ?? '';
              longitud = state.agentData.longitud ?? '';
              if (WService.location != null && WService.editLocation) {
                getSharedPrefs();
              } else {
                _addMarker(pos, false, "2", true);
              }
            } else {
              //address = "Avenida caminos del inca 777 ";
              latitud = "Localisation non enregistrée";
              longitud = "-";
              if (state.agentData.latitud == "-12.124656" &&
                  state.agentData.longitud == "-76.99395") {
                CustomSnackbar.snackBar(
                    contextSnack: context,
                    isError: true,
                    message: "Localisation Globokas");
              }
            }
          });
        }

        if (state is UpdateVisitState) {
          Map obj = {"visit": visitReceived, "stateStore": widget.isDown};
          Navigator.pushNamed(
            context,
            RegisterPhotoBannerViewRoute,
            arguments: obj,
          );
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
          CustomSnackbar.snackBar(
              contextSnack: context,
              isError: true,
              message: "Impossible de mettre à jour les données de l'agent");
        }
      },
      child: BlocBuilder<VisitBloc, VisitBlocState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }

  void _addMarker(LatLng pos, bool myLocation, String id, bool checkBound) {
    var colorMarker;
    bool drag = false;
    if (myLocation) {
      colorMarker = BitmapDescriptor.hueBlue;
      drag = false;
    } else {
      colorMarker = BitmapDescriptor.hueRed;
      drag = editPos;
      pos = new LatLng(pos.latitude - 0.000015, pos.longitude);
    }
    final Marker m = Marker(
        onDragEnd: ((value) async {
          if (editPos) {
            updateLocation = value;
            updateHeader(updateLocation);
            Future.delayed(Duration(milliseconds: 500), () => checkBounds());
          }
        }),
        draggable: drag,
        markerId: MarkerId(id),
        icon: BitmapDescriptor.defaultMarkerWithHue(colorMarker),
        position: pos);
    setState(() {
      if (markers.length >= 1 && myLocation) {
        markers.remove(markers.elementAt(0));
      } else if (markers.length >= 2 && !myLocation) {
        markers.remove(markers.elementAt(1));
      }
      markers.add(m);
      if (myLocation) {
        BlocProvider.of<VisitBloc>(context).add(GetLocationEvent(
            codeStore: visitReceived.codigo ?? '', state: visitReceived.estado ?? 0));
      } else {
        if (checkBound)
          Future.delayed(Duration(milliseconds: 500), () => checkBounds());
      }
    });
  }

  void checkBounds() {
    if (markers.length >= 1 && mapController != null) {
      List<LatLng> list = <LatLng>[];
      for (var no in markers) {
        list.add(new LatLng(no.position.latitude, no.position.longitude));
      }
      LatLngBounds bound = boundsFromLatLngList(list);
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
      mapController.animateCamera(u2).then((void v) {
        check(u2, mapController);
      });
    }
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  void updateHeader(LatLng value) {
    updateLocation = value;
    WService.location = value;
    setState(() {
      latitud = updateLocation.latitude.toStringAsFixed(6);
      longitud = updateLocation.longitude.toStringAsFixed(6);
    });

    updateLocation = new LatLng(double.parse(latitud), double.parse(longitud));
  }

  void resetLocation() {
    setState(() {
      if (currentlocation != null) {
        latitud = currentlocation.latitude.toStringAsFixed(6);
        longitud = currentlocation.longitude.toStringAsFixed(6);
      }
    });
  }

  Future<Null> getSharedPrefs() async {
    setState(() {
      editPos = WService.editLocation;
      if (WService.location != null && editPos) {
        updateHeader(WService.location!);
        _addMarker(WService.location!, false, "2", false);
      }
    });
  }

  double calculateDistance(double? lat1, double? lon1, double? lat2, double? lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
