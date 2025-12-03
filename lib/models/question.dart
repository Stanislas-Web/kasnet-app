class Questions {
  List<Question> items = [];
  Questions();
  Questions.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final question = Question.fromJson(item);
      items.add(question);
    }
  }
}

class Question {
  int? id;
  String? descripcion;
  String? fechaCreacion;
  String? esMultiple;
  int? estado;
  List? tsopcionPreguntaList;

  dynamic valor; // bool and string

  Question(
      {this.id,
      this.descripcion,
      this.valor,
      this.fechaCreacion,
      this.esMultiple,
      this.estado,
      this.tsopcionPreguntaList});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    fechaCreacion = json['fechaCreacion'];
    esMultiple = json['esMultiple'];
    estado = json['estado'];
    tsopcionPreguntaList = json['tsopcionPreguntaList'];

    valor = json['value'];
  }
}
