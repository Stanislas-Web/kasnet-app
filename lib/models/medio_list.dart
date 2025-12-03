class TsmedioList {
  int? id;
  String? imagen;
  String? nombreImagen;
  String? ruta;
  int? tipo;

  TsmedioList({this.id, this.imagen, this.nombreImagen, this.ruta, this.tipo});

  TsmedioList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagen = json['imagen'];
    nombreImagen = json['nombreImagen'];
    ruta = json['ruta'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagen'] = this.imagen;
    data['nombreImagen'] = this.nombreImagen;
    data['ruta'] = this.ruta;
    data['tipo'] = this.tipo;
    return data;
  }
}
