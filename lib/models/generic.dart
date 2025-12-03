class Generics {
  List<dynamic> items = [];
  Generics();
  Generics.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final generic = Generic.fromJson(item);
      items.add(generic);
    }
  }
}

class Generic {
  String? description;
  bool? value;

  Generic({this.description, this.value});

  Generic.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    value = json['value'];
  }
}
