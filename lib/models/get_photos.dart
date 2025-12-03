class GetPhotosResponseList {
  List<dynamic> items = [];
  GetPhotosResponseList();
  GetPhotosResponseList.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final answer = GetPhotosResponse.fromJson(item);
      items.add(answer);
    }
  }
}

class GetPhotosResponse {
  int? id;
  String? imagen;
  String? nombreImagen;
  String? fechaCreacion;
  String? ruta;
  int? tipo;

  GetPhotosResponse(
      {this.id,
      this.imagen,
      this.nombreImagen,
      this.fechaCreacion,
      this.ruta,
      this.tipo});

  GetPhotosResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagen = json['imagen'];
    nombreImagen = json['nombreImagen'];
    fechaCreacion = json['fechaCreacion'];
    ruta = json['ruta'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagen'] = this.imagen;
    data['nombreImagen'] = this.nombreImagen;
    data['fechaCreacion'] = this.fechaCreacion;
    data['ruta'] = this.ruta;
    data['tipo'] = this.tipo;
    return data;
  }
}
