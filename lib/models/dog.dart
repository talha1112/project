import 'package:test/models/breed.dart';

class Dog {
  int? id;
  String? name;
  String? birthday;
  String? weight;
  String? image;
  int? breedId;
  int? userId;
  String? description;
  String? city;
  String? zip;
  Null trusted;
  Breed? breed;

  Dog({
    this.id,
    this.name,
    this.birthday,
    this.weight,
    this.image,
    this.breedId,
    this.userId,
    this.description,
    this.city,
    this.zip,
    this.trusted,
    this.breed,
  });

  Dog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    birthday = json['birthday'];
    weight = json['weight'];
    image = json['image'];
    breedId = json['breed_id'];
    userId = json['user_id'];
    description = json['description'];
    city = json['city'];
    zip = json['zip'];
    trusted = json['trusted'];
    breed = json['breed'] != null ? Breed.fromJson(json['breed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['birthday'] = birthday;
    data['weight'] = weight;
    data['image'] = image;
    data['breed_id'] = breedId;
    data['user_id'] = userId;
    data['description'] = description;
    data['city'] = city;
    data['zip'] = zip;
    data['trusted'] = trusted;
    if (breed != null) {
      data['breed'] = breed!.toJson();
    }
    return data;
  }
}
