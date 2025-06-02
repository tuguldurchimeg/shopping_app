import 'package:mobile_final/models/address_model.dart';

class UserModel {
  final String email;
  final String username;
  final String phone;
  final AddressModel address;

  UserModel({
    required this.email,
    required this.username,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      address: AddressModel.fromJson(
        (json['address'] is Map)
            ? Map<String, dynamic>.from(json['address'])
            : {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
      'address': address?.toJson(),
    };
  }
}
