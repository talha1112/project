class ValidationError {
  String? name;
  String? email;
  String? password;
  ValidationError({this.email, this.password, this.name});

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
        name: json['name'].toString(),
        email: json['email'].toString(),
        password: json['password'].toString());
  }
}

class ValidationErrorCreateBid {
  String? startDate;
  String? endDate;
  ValidationErrorCreateBid({this.startDate, this.endDate});

  factory ValidationErrorCreateBid.fromJson(Map<String, dynamic> json) {
    return ValidationErrorCreateBid(
      startDate: json['startDate'].toString(),
      endDate: json['endDate'].toString(),
    );
  }
}
