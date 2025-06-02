class AddressModel {
  final String city;
  final String street;
  final int number;

  AddressModel({
    required this.city,
    required this.street,
    required this.number,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'],
      street: json['street'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'street': street, 'number': number};
  }

  @override
  String toString() {
    return "$number $street, $city";
  }
}
