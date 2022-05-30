class Student {
  final int? id;
  final String firstname;
  final String secondname;
  final String groupp;
  final int course;
  final String social;
  final int rating;
  final String debt;
  Student({
    this.id,
    required this.firstname,
    required this.secondname,
    required this.course,
    required this.groupp,
    required this.social,
    required this.rating,
    required this.debt
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
    id: json['id'],
    firstname: json["firstname"],
    secondname: json['secondname'],
    course: json["course"],
    groupp: json["groupp"],
    social: json["social"],
    rating: json["rating"],
    debt: json["debt"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'secondname': secondname,
      'course': course,
      'groupp': groupp,
      'social': social,
      'rating': rating,
      'debt': debt,
    };
  }
}
