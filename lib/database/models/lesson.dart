class Lesson {
  final int? id;
  final String name;
  final int building;
  final int classroom;
  final String groupp;
  final int course;
  final int date;
  final int starttime;
  final String type;
  final int state;
  Lesson({
    this.id,
    required this.name,
    required this.building,
    required this.classroom,
    required this.groupp,
    required this.course,
    required this.date,
    required this.starttime,
    required this.type,
    required this.state,
  });

  factory Lesson.fromMap(Map<String, dynamic> json) => Lesson(
    id: json['id'],
    name: json['name'],
    building: json['building'],
    classroom: json['classroom'],
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
      'building': building,
      'classroom': classroom,
      'groupp': groupp,
      'course': course,
      'date': date,
      'starttime': starttime,
      'type': type,
      'state': state,
    };
  }
}
