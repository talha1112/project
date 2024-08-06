import 'walker.dart';

class Bid {
  int? id;
  int? walker_id;
  String? walker_name;
  String? profile_image;
  String? price;
  String? fee;
  String? total;
  String? score;
  String? trusted;
  Walker? walker;

  Bid({
    this.id,
    this.walker_id,
    this.walker_name,
    this.profile_image,
    this.price,
    this.fee,
    this.total,
    this.score,
    this.trusted,
    this.walker,
  });

  Bid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walker_id = json['walker_id'];
    walker_name = json['walker_name'] ?? '';
    profile_image = json['profile_image'] ?? '';
    price = json['price'] ?? '0';
    fee = json['fee'] ?? '0';
    total = json['total'] ?? '0';
    score = json['score'] ?? '0';
    trusted = json['trusted'] ?? '0';
    walker = json['walker'] != null ? Walker.fromJson(json['walker']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['walker_id'] = walker_id;
    data['walker_name'] = walker_name;
    data['profile_image'] = profile_image;
    data['price'] = price;
    data['fee'] = fee;
    data['total'] = total;
    data['score'] = score;
    data['trusted'] = trusted;
    if (walker != null) {
      data['walker'] = walker!.toJson();
    }
    return data;
  }
}
