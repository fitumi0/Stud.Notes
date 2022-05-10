class Student {
  final int? id;
  final String secondname;
  final String firstname;
  final String groupp;
  final int course;
  final String email;
  final String VK;
  final String TG;
  final int rating;
  Student({
    this.id,
    required this.secondname,
    required this.firstname,
    required this.course,
    required this.groupp,
    required this.email,
    required this.VK,
    required this.TG,
    required this.rating
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
    id: json['id'],
    secondname: json['secondname'],
    firstname: json["firstname"],
    course: json["course"],
    groupp: json["groupp"],
    email: json["email"],
    VK: json["VK"],
    TG: json["TG"],
    rating: json["rating"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secondname': secondname,
      'firstname': firstname,
      'course': course,
      'groupp': groupp,
      'email': email,
      'VK': VK,
      'TG': TG,
      'rating': rating,
    };
  }
}
