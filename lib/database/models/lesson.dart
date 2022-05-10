class Lesson {
  final int? id;
  final String name;
  final String groupp;
  final int course;
  final int date;
  final String starttime;
  final String type;
  final int state;
  Lesson({
    this.id,
    required this.name,
    required this.groupp,
    required this.course,
    required this.date,
    required this.starttime,
    required this.type,
    required this.state
  });

  factory Lesson.fromMap(Map<String, dynamic> json) => new Lesson(
    id: json['id'],
    name: json['name'],
    groupp: json["groupp"],
    course: json["course"],
    date: json["date"],
    starttime: json["starttime"],
    type: json["type"],
    state: json["state"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groupp': groupp,
      'course': course,
      'date': date,
      'start': starttime,
      'type': type,
      'state': state,
    };
  }
}
