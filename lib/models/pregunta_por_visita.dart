import 'tipo_pregunta_por_visita.dart';
import 'tipo_pregunta.dart';

class TrpreguntaXvisitaList {
  Tppregunta? tppregunta;
  TrpreguntaXvisitaPK? trpreguntaXvisitaPK;
  String? valor;

  TrpreguntaXvisitaList(
      {this.tppregunta, this.trpreguntaXvisitaPK, this.valor});

  TrpreguntaXvisitaList.fromJson(Map<String, dynamic> json) {
    tppregunta = json['tppregunta'] != null
        ? new Tppregunta.fromJson(json['tppregunta'])
        : null;
    trpreguntaXvisitaPK = json['trpreguntaXvisitaPK'] != null
        ? new TrpreguntaXvisitaPK.fromJson(json['trpreguntaXvisitaPK'])
        : null;
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tppregunta != null) {
      data['tppregunta'] = this.tppregunta?.toJson();
    }
    if (this.trpreguntaXvisitaPK != null) {
      data['trpreguntaXvisitaPK'] = this.trpreguntaXvisitaPK?.toJson();
    }
    data['valor'] = this.valor;
    return data;
  }
}
