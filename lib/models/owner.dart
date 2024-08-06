class Owner {
  int? id;
  String? name;
  String? email;
  String? profile_image;
  String? role;
  String? city;
  String? city_id;
  String? zip;
  String? zip_id;
  String? score;
  String? street;
  String? house_number;
  String? phone;
  String? about_me;

  Owner({
    this.id,
    this.name,
    this.email,
    this.profile_image,
    this.role,
    this.city,
    this.city_id,
    this.zip,
    this.zip_id,
    this.score,
    this.street,
    this.house_number,
    this.phone,
    this.about_me,
  });

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profile_image = json['profile_image'];
    role = json['role'];
    city = json['city'];
    city_id = json['city_id'];
    zip = json['zip'];
    zip_id = json['zip_id'];
    score = json['score'];
    street = json['street'];
    house_number = json['house_number'];
    phone = json['phone'];
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
    data['city_id'] = city_id;
    data['zip'] = zip;
    data['zip_id'] = zip_id;
    data['score'] = score;
    data['street'] = street;
    data['house_number'] = house_number;
    data['phone'] = phone;
    data['about_me'] = about_me;
    return data;
  }
}
