class Turnes {
  List<Turne> items = [];
  Turnes();
  Turnes.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final turne = Turne.fromJson(item);
      items.add(turne);
    }
  }
}

class Turne {
  String? description;
  bool? value;

  Turne({this.description, this.value});

  Turne.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    value = json['value'];
  }
}
