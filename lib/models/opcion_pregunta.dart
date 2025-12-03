class TsopcionPreguntaList {
  int? id;
  String? valor;

  TsopcionPreguntaList({this.id, this.valor});

  TsopcionPreguntaList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valor = json['valor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valor'] = this.valor;
    return data;
  }
}
