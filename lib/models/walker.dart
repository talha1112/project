class Walker {
  int? id;
  String? name;
  String? email;
  String? profile_image;
  String? role;
  String? city;
  String? zip;
  String? score;
  String? trusted;
  String? phone;
  String? city_id;
  String? zip_id;
  String? street;
  String? house_number;
  String? about_me;

  Walker({
    this.id,
    this.name,
    this.email,
    this.profile_image,
    this.role,
    this.city,
    this.zip,
    this.score,
    this.trusted,
    this.phone,
    this.city_id,
    this.zip_id,
    this.street,
    this.house_number,
    this.about_me,
  });

  Walker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profile_image = json['profile_image'];
    role = json['role'];
    city = json['city'];
    zip = json['zip'];
    score = json['score'];
    trusted = json['trusted'];
    phone = json['phone'];
    city_id = json['city_id'];
    zip_id = json['zip_id'];
    street = json['street'];
    house_number = json['house_number'];
    about_me = json['about_me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profile_image;
    data['role'] = role;
    data['city'] = city;
    data['zip'] = zip;
    data['score'] = score;
    data['trusted'] = trusted;
    data['phone'] = phone;
    data['city_id'] = city_id;
    data['zip_id'] = zip_id;
    data['street'] = street;
    data['house_number'] = house_number;
    data['about_me'] = about_me;
    return data;
  }
}
