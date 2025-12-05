class Agents {
  List<Agent> items = <Agent>[];
  Agents();
  Agents.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    } else {
      for (var item in jsonList) {
        final answer = new Agent.fromJson(item);
        items.add(answer);
      }
    }
  }
}

class Agent {
  StateAgent? estado;
  String? codigo;
  String? nombreComercio;
  late bool value;
  //
  int? id;
  // String codigo;
  // String nombreComercio;
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
  List? diasDisponibles;
  List? horasDisponibles;
  bool? firmaActaDesinstalacion;
  // "tipoGestion": null,
  // Map estadoObject;

  Agent(
      {this.estado = null,
      this.codigo,
      this.nombreComercio,
      //
      this.id,
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
      this.firmaActaDesinstalacion});

  Agent.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nombreComercio = json['nombreComercio'];
    // Gérer le cas où 'estado' est un String ou un objet
    if (json['estado'] is String) {
      estado = new StateAgent(nombre: json['estado'], fecha: null);
    } else if (json['estado'] is Map) {
      estado = new StateAgent(
          nombre: json['estado']['nombre'], fecha: json['estado']['fecha']);
    }
    //
    id = json['id'];
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
    horasDisponibles = json['diasDisponibles'];
    diasDisponibles = json['horasDisponibles'];
    firmaActaDesinstalacion = json['firmaActaDesinstalacion'];
  }
}

class StateAgent {
  String? nombre;
  String? fecha;

  StateAgent({this.nombre, this.fecha});
}
