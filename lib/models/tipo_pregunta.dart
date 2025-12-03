import 'opcion_pregunta.dart';
import 'id.dart';

class Tppregunta {
  Id? iId;
  String? descripcion;
  String? esMultiple;
  int? estado;
  String? fechaCreacion;
  int? id;
  List<TsopcionPreguntaList>? tsopcionPreguntaList;

  Tppregunta(
      {this.iId,
      this.descripcion,
      this.esMultiple,
      this.estado,
      this.fechaCreacion,
      this.id,
      this.tsopcionPreguntaList});

  Tppregunta.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    descripcion = json['descripcion'];
    esMultiple = json['esMultiple'];
    estado = json['estado'];
    fechaCreacion = json['fechaCreacion'];
    id = json['id'];
    if (json['tsopcionPreguntaList'] != null) {
      tsopcionPreguntaList = <TsopcionPreguntaList>[];
      json['tsopcionPreguntaList'].forEach((v) {
        tsopcionPreguntaList?.add(TsopcionPreguntaList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId?.toJson();
    }
    data['descripcion'] = this.descripcion;
    data['esMultiple'] = this.esMultiple;
    data['estado'] = this.estado;
    data['fechaCreacion'] = this.fechaCreacion;
    data['id'] = this.id;
    if (this.tsopcionPreguntaList != null) {
      data['tsopcionPreguntaList'] =
          this.tsopcionPreguntaList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
