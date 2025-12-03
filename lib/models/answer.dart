class Answers {
  List<Answer> items = <Answer>[];
  Answers();
  Answers.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    } else {
      for (var item in jsonList) {
        final answer = Answer.fromJson(item);
        items.add(answer);
      }
    }
  }
}

class Answer {
  int? id;
  late String descripcion;
  bool? valor;

  Answer({this.id, required this.descripcion, this.valor});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    valor = json['valor'];
  }
}
