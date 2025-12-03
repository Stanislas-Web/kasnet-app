class Id {
  int? counter;
  String? date;
  int? machineIdentifier;
  int? processIdentifier;
  int? time;
  int? timeSecond;
  int? timestamp;

  Id(
      {this.counter,
      this.date,
      this.machineIdentifier,
      this.processIdentifier,
      this.time,
      this.timeSecond,
      this.timestamp});

  Id.fromJson(Map<String, dynamic> json) {
    counter = json['counter'];
    date = json['date'];
    machineIdentifier = json['machineIdentifier'];
    processIdentifier = json['processIdentifier'];
    time = json['time'];
    timeSecond = json['timeSecond'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['counter'] = this.counter;
    data['date'] = this.date;
    data['machineIdentifier'] = this.machineIdentifier;
    data['processIdentifier'] = this.processIdentifier;
    data['time'] = this.time;
    data['timeSecond'] = this.timeSecond;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
