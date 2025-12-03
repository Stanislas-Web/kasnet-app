import 'pregunta_por_visita.dart';
import 'tipos_gestion.dart';
import 'medio_list.dart';

class AgentData {
  late String celularOperador;
  late String codigo;
  late String comentario;
  late String correoElectronico;
  late String correoElectronico2;
  late String correoElectronicoOperador;
  late List<String> diasDisponibles;
  late String esTitular;
  late int estado;
  late String estadoAgente;
  late String fechaCreacion;
  late String fechaInstalacion;
  late bool firmaActaDesinstalacion;
  late List<String> horasDisponibles;
  late int id;
  late String latitud;
  late String longitud;
  late String nombreComercio;
  late String nombreOperador;
  late String nombreTitular;
  late String telefono;
  late String telefonoContacto2;
  late String tipoTelefono;
  late String tipoTelefonoContacto2;
  late List<TiposGestion> tiposGestion;
  late List<TrpreguntaXvisitaList> trpreguntaXvisitaList;
  late List<TsmedioList> tsmedioList;
  late String username;

  AgentData({
    required this.celularOperador,
    required this.codigo,
    required this.comentario,
    required this.correoElectronico,
    required this.correoElectronico2,
    required this.correoElectronicoOperador,
    required this.diasDisponibles,
    required this.esTitular,
    required this.estado,
    required this.estadoAgente,
    required this.fechaCreacion,
    required this.fechaInstalacion,
    required this.firmaActaDesinstalacion,
    required this.horasDisponibles,
    required this.id,
    required this.latitud,
    required this.longitud,
    required this.nombreComercio,
    required this.nombreOperador,
    required this.nombreTitular,
    required this.telefono,
    required this.telefonoContacto2,
    required this.tipoTelefono,
    required this.tipoTelefonoContacto2,
    required this.tiposGestion,
    required this.trpreguntaXvisitaList,
    required this.tsmedioList,
    required this.username,
  });

  AgentData.fromJson(Map<String, dynamic> json) {
    celularOperador = json['celularOperador'];
    codigo = json['codigo'];
    comentario = json['comentario'];
    correoElectronico = json['correoElectronico'];
    correoElectronico2 = json['correoElectronico2'];
    correoElectronicoOperador = json['correoElectronicoOperador'];
    diasDisponibles = json['diasDisponibles'].cast<String>();
    esTitular = json['esTitular'];
    estado = json['estado'];
    estadoAgente = json['estadoAgente'];
    fechaCreacion = json['fechaCreacion'];
    fechaInstalacion = json['fechaInstalacion'];
    firmaActaDesinstalacion = json['firmaActaDesinstalacion'];
    horasDisponibles = json['horasDisponibles'].cast<String>();
    id = json['id'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    nombreComercio = json['nombreComercio'];
    nombreOperador = json['nombreOperador'];
    nombreTitular = json['nombreTitular'];
    telefono = json['telefono'];
    telefonoContacto2 = json['telefonoContacto2'];
    tipoTelefono = json['tipoTelefono'];
    tipoTelefonoContacto2 = json['tipoTelefonoContacto2'];
    if (json['tiposGestion'] != null) {
      tiposGestion = <TiposGestion>[];
      json['tiposGestion'].forEach((v) {
        tiposGestion.add(TiposGestion.fromJson(v));
      });
    }
    if (json['trpreguntaXvisitaList'] != null) {
      trpreguntaXvisitaList = <TrpreguntaXvisitaList>[];
      json['trpreguntaXvisitaList'].forEach((v) {
        trpreguntaXvisitaList.add(TrpreguntaXvisitaList.fromJson(v));
      });
    }
    if (json['tsmedioList'] != null) {
      tsmedioList = <TsmedioList>[];
      json['tsmedioList'].forEach((v) {
        tsmedioList.add(TsmedioList.fromJson(v));
      });
    }
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['celularOperador'] = this.celularOperador;
    data['codigo'] = this.codigo;
    data['comentario'] = this.comentario;
    data['correoElectronico'] = this.correoElectronico;
    data['correoElectronico2'] = this.correoElectronico2;
    data['correoElectronicoOperador'] = this.correoElectronicoOperador;
    data['diasDisponibles'] = this.diasDisponibles;
    data['esTitular'] = this.esTitular;
    data['estado'] = this.estado;
    data['estadoAgente'] = this.estadoAgente;
    data['fechaCreacion'] = this.fechaCreacion;
    data['fechaInstalacion'] = this.fechaInstalacion;
    data['firmaActaDesinstalacion'] = this.firmaActaDesinstalacion;
    data['horasDisponibles'] = this.horasDisponibles;
    data['id'] = this.id;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['nombreComercio'] = this.nombreComercio;
    data['nombreOperador'] = this.nombreOperador;
    data['nombreTitular'] = this.nombreTitular;
    data['telefono'] = this.telefono;
    data['telefonoContacto2'] = this.telefonoContacto2;
    data['tipoTelefono'] = this.tipoTelefono;
    data['tipoTelefonoContacto2'] = this.tipoTelefonoContacto2;
    if (this.tiposGestion != null) {
      data['tiposGestion'] = this.tiposGestion.map((v) => v.toJson()).toList();
    }
    if (this.trpreguntaXvisitaList != null) {
      data['trpreguntaXvisitaList'] =
          this.trpreguntaXvisitaList.map((v) => v.toJson()).toList();
    }
    if (this.tsmedioList != null) {
      data['tsmedioList'] = this.tsmedioList.map((v) => v.toJson()).toList();
    }
    data['username'] = this.username;
    return data;
  }
}
