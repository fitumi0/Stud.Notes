class DropDownListModel {
  final int? id;
  final String name;
  DropDownListModel({
    this.id,
    required this.name,
  });

  factory DropDownListModel.fromMap(Map<String, dynamic> json) => new DropDownListModel(
    id: json['id'],
    name: json['name']
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
