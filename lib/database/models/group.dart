class Group {
  final int? id;
  final String name;
  final int course;
  Group({
    this.id,
    required this.name,
    required this.course,
  });

  factory Group.fromMap(Map<String, dynamic> json) => new Group(
    id: json['id'],
    name: json['name'],
    course: json["course"]
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
    };
  }
}
