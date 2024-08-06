import 'package:test/models/walker.dart';

import 'bid.dart';
import 'dog.dart';
import 'owner.dart';

class Walk {
  int? id;
  int? ownerId;
  int? walkerId;
  int? dogId;
  String? from;
  String? to;
  String? price;
  String? arrived;
  String? walkStart;
  String? returned;
  String? walkEnd;
  String? cancel;
  String? zip;
  String? city;
  String? street;
  String? count;
  Owner? owner;
  Walker? walker;
  Dog? dog;
  List<Bid>? bids;
  String? bidprice;

  Walk({
    this.id,
    this.ownerId,
    this.walkerId,
    this.dogId,
    this.from,
    this.to,
    this.price,
    this.arrived,
    this.walkStart,
    this.returned,
    this.walkEnd,
    this.cancel,
    this.zip,
    this.city,
    this.street,
    this.count,
    this.owner,
    this.walker,
    this.dog,
    this.bids,
    this.bidprice,
  });

  Walk.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    ownerId = json['owner_id'] ?? 0;
    walkerId = json['walker_id'] ?? 0;
    dogId = json['dog_id'];
    from = json['from'];
    to = json['to'];
    price = json['price'];
    arrived = json['arrived'];
    walkStart = json['walk_start'];
    returned = json['returned'];
    walkEnd = json['walk_end'];
    cancel = json['cancel'];
    zip = json['zip'];
    city = json['city'];
    street = json['street'];
    count = json['count'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    walker = json['walker'] != null ? Walker.fromJson(json['walker']) : null;
    dog = json['dog'] != null ? Dog.fromJson(json['dog']) : null;
    if (json['bids'] != null) {
      bids = <Bid>[];
      json['bids'].forEach((v) {
        bids!.add(Bid.fromJson(v));
      });
    }
    bidprice = json['bidprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['walker_id'] = walkerId;
    data['dog_id'] = dogId;
    data['from'] = from;
    data['to'] = to;
    data['price'] = price;
    data['arrived'] = arrived;
    data['walk_start'] = walkStart;
    data['returned'] = returned;
    data['walk_end'] = walkEnd;
    data['cancel'] = cancel;
    data['zip'] = zip;
    data['city'] = city;
    data['street'] = street;
    data['count'] = count;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    if (walker != null) {
      data['walker'] = walker!.toJson();
    }
    if (dog != null) {
      data['dog'] = dog!.toJson();
    }
    if (bids != null) {
      data['bids'] = bids!.map((v) => v.toJson()).toList();
    }
    data['bidprice'] = bidprice;

    return data;
  }
}
