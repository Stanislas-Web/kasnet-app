class AnswersOther {
  List<AnswerOther> items = <AnswerOther>[];
  AnswersOther();
  AnswersOther.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    } else {
      for (var item in jsonList) {
        final answer = new AnswerOther.fromJson(item);
        items.add(answer);
      }
    }
  }
}

class AnswerOther {
  int? id;
  String? descripcion;
  String? valor;

  AnswerOther({this.id, this.descripcion, this.valor});

  AnswerOther.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['valor'];
    valor = "";
  }
}
