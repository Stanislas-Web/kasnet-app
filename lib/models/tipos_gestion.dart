class TiposGestion {
  String? accion;
  bool? activo;
  String? codigo;
  String? descripcion;
  List<int>? flujoDePantallas;

  TiposGestion(
      {this.accion,
      this.activo,
      this.codigo,
      this.descripcion,
      this.flujoDePantallas});

  TiposGestion.fromJson(Map<String, dynamic> json) {
    accion = json['accion'];
    activo = json['activo'];
    codigo = json['codigo'];
    descripcion = json['descripcion'];
    flujoDePantallas = json['flujoDePantallas'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accion'] = this.accion;
    data['activo'] = this.activo;
    data['codigo'] = this.codigo;
    data['descripcion'] = this.descripcion;
    data['flujoDePantallas'] = this.flujoDePantallas;
    return data;
  }
}
