class User {
  String? id;
  String? role;
  String? name;
  String? email;
  User({this.id, this.role, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'].toString(),
        role: json['role'].toString(),
        name: json['name'].toString(),
        email: json['email'].toString());
  }
}
