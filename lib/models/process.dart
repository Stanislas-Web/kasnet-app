class Processes {
  List<Process> items = [];
  Processes();
  Processes.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final process = Process.fromJson(item);
      items.add(process);
    }
  }
}

class Process {
  String? descripcion;
  String? codigo;
  String? accion;
  bool? activo;
  bool? valor;
  List<dynamic>? flujoDePantallas;

  Process(
      {this.descripcion,
      this.codigo,
      this.accion,
      this.activo,
      this.valor,
      this.flujoDePantallas});

  Process.fromJson(Map<String, dynamic> json) {
    descripcion = json['descripcion'];
    codigo = json['codigo'];
    accion = json['accion'];
    activo = json['activo'];
    valor = false;
    flujoDePantallas = json['flujoDePantallas'];
  }
}
