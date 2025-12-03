class Visits {
  List<Visit> items = [];
  Visits();
  Visits.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final answer = Visit.fromJson(item);
      items.add(answer);
    }
  }
}

class Visit {
  int? id;
  String? username;
  int? estado;
  String? fechaCreacion;
  String? estadoAgente;
  String? comentario;
  String? codigo;
  String? nombreComercio;
  String? latitud;
  String? longitud;
  String? fechaInstalacion;
  String? telefono;
  String? correoElectronico;
  String? correoElectronico2;
  String? telefonoContacto2;
  String? esTitular;
  String? tipoTelefono;
  String? tipoTelefonoContacto2;
  bool? firmaActaDesinstalacion;
  List? tipoGestion;
  List? diasDisponibles;
  List? horasDisponibles;
  String? nombreTitular;
  String? nombreOperador;
  String? celularOperador;
  String? correoElectronicoOperador;
  List? trpreguntaXvisitaList;
  List? tsmedioList;

  Visit(
      {this.id,
      this.username,
      this.estado,
      this.fechaCreacion,
      this.estadoAgente,
      this.comentario,
      this.codigo,
      this.nombreComercio,
      this.latitud,
      this.longitud,
      this.fechaInstalacion,
      this.telefono,
      this.correoElectronico,
      this.correoElectronico2,
      this.telefonoContacto2,
      this.esTitular,
      this.tipoTelefono,
      this.tipoTelefonoContacto2,
      this.firmaActaDesinstalacion,
      this.tipoGestion,
      this.diasDisponibles,
      this.horasDisponibles,
      this.nombreTitular,
      this.nombreOperador,
      this.celularOperador,
      this.correoElectronicoOperador,
      this.trpreguntaXvisitaList,
      this.tsmedioList});

  Visit.fromJson(Map<String, dynamic> json) {
    // codigo          = json['codigo'];
    // nombreComercio  = json['nombreComercio'];
    // estado          = new State(nombre: json['estado']['nombre'], fecha: json['estado']['fecha']);
    id = (json['id'] == null) ? 0 : json['id'];
    username = (json['username'] == null) ? "" : json['username'];
    estado = (json['estado'] == null) ? 0 : json['estado'];
    fechaCreacion =
        (json['fechaCreacion'] == null) ? "" : json['fechaCreacion'];
    estadoAgente = (json['estadoAgente'] == null) ? "" : json['estadoAgente'];
    comentario = (json['comentario'] == null) ? "" : json['comentario'];
    codigo = (json['codigo'] == null) ? "" : json['codigo'];
    nombreComercio =
        (json['nombreComercio'] == null) ? "" : json['nombreComercio'];
    latitud = (json['latitud'] == null) ? "" : json['latitud'];
    longitud = (json['longitud'] == null) ? "" : json['longitud'];
    fechaInstalacion =
        (json['fechaInstalacion'] == null) ? "" : json['fechaInstalacion'];
    telefono = (json['telefono'] == null) ? "" : json['telefono'];
    correoElectronico =
        (json['correoElectronico'] == null) ? "" : json['correoElectronico'];
    correoElectronico2 =
        (json['correoElectronico2'] == null) ? "" : json['correoElectronico2'];
    telefonoContacto2 =
        (json['telefonoContacto2'] == null) ? "" : json['telefonoContacto2'];
    esTitular = (json['esTitular'] == null) ? "" : json['esTitular'];
    tipoTelefono = (json['tipoTelefono'] == null) ? "" : json['tipoTelefono'];
    tipoTelefonoContacto2 = (json['tipoTelefonoContacto2'] == null)
        ? ""
        : json['tipoTelefonoContacto2'];
    firmaActaDesinstalacion = (json['firmaActaDesinstalacion'] == null)
        ? null
        : json['firmaActaDesinstalacion'];
    tipoGestion = (json['tiposGestion'] == null) ? [] : json['tiposGestion'];
    diasDisponibles =
        (json['diasDisponibles'] == null) ? [] : json['diasDisponibles'];
    horasDisponibles =
        (json['horasDisponibles'] == null) ? [] : json['horasDisponibles'];
    nombreTitular =
        (json['nombreTitular'] == null) ? "" : json['nombreTitular'];
    nombreOperador =
        (json['nombreOperador'] == null) ? "" : json['nombreOperador'];
    celularOperador =
        (json['celularOperador'] == null) ? "" : json['celularOperador'];
    correoElectronicoOperador = (json['correoElectronicoOperador'] == null)
        ? ""
        : json['correoElectronicoOperador'];
    trpreguntaXvisitaList = (json['trpreguntaXvisitaList'] == null)
        ? []
        : json['trpreguntaXvisitaList'];
    tsmedioList = (json['tsmedioList'] == null) ? [] : json['tsmedioList'];
  }

  Map<String, dynamic> toJson() => {
        // codigo          = json['codigo'];
        // nombreComercio  = json['nombreComercio'];
        // estado          = new State(nombre: json['estado']['nombre'], fecha: json['estado']['fecha']);

        'id': id,
        'username': username,
        'estado': estado,
        'fechaCreacion': fechaCreacion,
        'estadoAgente': estadoAgente,
        'comentario': comentario,
        'codigo': codigo,
        'nombreComercio': nombreComercio,
        'latitud': latitud,
        'longitud': longitud,
        'fechaInstalacion': fechaInstalacion,
        'telefono': telefono,
        'correoElectronico': correoElectronico,
        'correoElectronico2': correoElectronico2,
        'telefonoContacto2': telefonoContacto2,
        'esTitular': esTitular,
        'tipoTelefono': tipoTelefono,
        'tipoTelefonoContacto2': tipoTelefonoContacto2,
        'firmaActaDesinstalacion': firmaActaDesinstalacion,
        'tipoGestion': tipoGestion,
        'diasDisponibles': diasDisponibles,
        'horasDisponibles': horasDisponibles,
        'nombreTitular': nombreTitular,
        'nombreOperador': nombreOperador,
        'celularOperador': celularOperador,
        'correoElectronicoOperador': correoElectronicoOperador,
        'trpreguntaXvisitaList': trpreguntaXvisitaList,
        'tsmedioList': tsmedioList
      };
}
