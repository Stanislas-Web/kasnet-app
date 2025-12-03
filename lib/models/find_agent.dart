class FindAgentResponse {
  String? id;
  String? codigo;
  String? nombreComercio;
  String? direccion;
  String? latitud;
  String? longitud;
  String? nombreTitular;
  String? telefono;
  String? correoElectronico;
  String? correoElectronico2;
  String? telefonoContacto2;
  String? esTitular;
  String? fechaModificacion;
  String? fechaInstalacion;
  String? esAgentePrueba;
  String? tipoTelefono;
  String? tipoTelefonoContacto2;
  String? nombreOperador;
  String? celularOperador;
  String? correoElectronicoOperador;
  List<String>? diasDisponibles;
  List<String>? horasDisponibles;
  bool? firmaActaDesinstalacion;
  Null? tipoGestion;
  Estado? estado;

  FindAgentResponse(
      {this.id,
      this.codigo,
      this.nombreComercio,
      this.direccion,
      this.latitud,
      this.longitud,
      this.nombreTitular,
      this.telefono,
      this.correoElectronico,
      this.correoElectronico2,
      this.telefonoContacto2,
      this.esTitular,
      this.fechaModificacion,
      this.fechaInstalacion,
      this.esAgentePrueba,
      this.tipoTelefono,
      this.tipoTelefonoContacto2,
      this.nombreOperador,
      this.celularOperador,
      this.correoElectronicoOperador,
      this.diasDisponibles,
      this.horasDisponibles,
      this.firmaActaDesinstalacion,
      this.tipoGestion,
      this.estado});

  FindAgentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codigo = json['codigo'];
    nombreComercio = json['nombreComercio'];
    direccion = json['direccion'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    nombreTitular = json['nombreTitular'];
    telefono = json['telefono'];
    correoElectronico = json['correoElectronico'];
    correoElectronico2 = json['correoElectronico2'];
    telefonoContacto2 = json['telefonoContacto2'];
    esTitular = json['esTitular'];
    fechaModificacion = json['fechaModificacion'];
    fechaInstalacion = json['fechaInstalacion'];
    esAgentePrueba = json['esAgentePrueba'];
    tipoTelefono = json['tipoTelefono'];
    tipoTelefonoContacto2 = json['tipoTelefonoContacto2'];
    nombreOperador = json['nombreOperador'];
    celularOperador = json['celularOperador'];
    correoElectronicoOperador = json['correoElectronicoOperador'];
    diasDisponibles = json['diasDisponibles'] != null
        ? json['diasDisponibles'].cast<String>()
        : null;
    horasDisponibles = json['horasDisponibles'] != null
        ? json['horasDisponibles'].cast<String>()
        : null;
    firmaActaDesinstalacion = json['firmaActaDesinstalacion'];
    tipoGestion = json['tipoGestion'];
    estado =
        json['estado'] != null ? new Estado.fromJson(json['estado']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['codigo'] = this.codigo;
    data['nombreComercio'] = this.nombreComercio;
    data['direccion'] = this.direccion;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['nombreTitular'] = this.nombreTitular;
    data['telefono'] = this.telefono;
    data['correoElectronico'] = this.correoElectronico;
    data['correoElectronico2'] = this.correoElectronico2;
    data['telefonoContacto2'] = this.telefonoContacto2;
    data['esTitular'] = this.esTitular;
    data['fechaModificacion'] = this.fechaModificacion;
    data['fechaInstalacion'] = this.fechaInstalacion;
    data['esAgentePrueba'] = this.esAgentePrueba;
    data['tipoTelefono'] = this.tipoTelefono;
    data['tipoTelefonoContacto2'] = this.tipoTelefonoContacto2;
    data['nombreOperador'] = this.nombreOperador;
    data['celularOperador'] = this.celularOperador;
    data['correoElectronicoOperador'] = this.correoElectronicoOperador;
    data['diasDisponibles'] = this.diasDisponibles;
    data['horasDisponibles'] = this.horasDisponibles;
    data['firmaActaDesinstalacion'] = this.firmaActaDesinstalacion;
    data['tipoGestion'] = this.tipoGestion;
    if (this.estado != null) {
      data['estado'] = this.estado?.toJson();
    }
    return data;
  }
}

class Estado {
  String? nombre;
  String? fecha;

  Estado({this.nombre, this.fecha});

  Estado.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    fecha = json['fecha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['fecha'] = this.fecha;
    return data;
  }
}
