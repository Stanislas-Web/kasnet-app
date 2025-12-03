class Days {
  List<Day> items = <Day>[];
  Days();
  Days.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    } else {
      for (var item in jsonList) {
        final day = new Day.fromJson(item);
        items.add(day);
      }
    }
  }
}

class Day {
  String? description;
  bool? value;

  Day({this.description, this.value});

  Day.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    value = json['value'];
  }
}
