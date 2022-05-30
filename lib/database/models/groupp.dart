class Groupp {
  final String name;
  final int course;
  Groupp({
    required this.name,
    required this.course,
  });

  factory Groupp.fromMap(Map<String, dynamic> json) => new Groupp(
      name: json['name'],
      course: json['course']
  );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'course': course
    };
  }
}
