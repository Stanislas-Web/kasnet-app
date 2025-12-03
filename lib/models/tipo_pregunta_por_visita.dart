class TrpreguntaXvisitaPK {
  int? preguntaId;
  int? visitaId;

  TrpreguntaXvisitaPK({this.preguntaId, this.visitaId});

  TrpreguntaXvisitaPK.fromJson(Map<String, dynamic> json) {
    preguntaId = json['preguntaId'];
    visitaId = json['visitaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preguntaId'] = this.preguntaId;
    data['visitaId'] = this.visitaId;
    return data;
  }
}
