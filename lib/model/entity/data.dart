class Data {
  int? id;
  String value;

  Data({this.id, required this.value});

  Map<String, dynamic> toMap() => {'id': id, 'value': value};

  @override
  String toString() => 'Data(id: $id, value: $value)';
}
