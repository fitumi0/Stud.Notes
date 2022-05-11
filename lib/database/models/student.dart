class Student {
  final int? id;
  final String secondname;
  final String firstname;
  final String groupp;
  final int course;
  final String social;
  final int rating;
  Student({
    this.id,
    required this.secondname,
    required this.firstname,
    required this.course,
    required this.groupp,
    required this.social,
    required this.rating
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
    id: json['id'],
    secondname: json['secondname'],
    firstname: json["firstname"],
    course: json["course"],
    groupp: json["groupp"],
    social: json["social"],
    rating: json["rating"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secondname': secondname,
      'firstname': firstname,
      'course': course,
      'groupp': groupp,
      'social': social,
      'rating': rating,
    };
  }
}
