import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_final/models/address_model.dart';
import 'package:mobile_final/models/user.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("❌ Login error: $e");
      return null;
    }
  }

  Future<User?> register({
    required String email,
    required String password,
    required String username,
    required String phone,
    required AddressModel address,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final uid = result.user!.uid;

        final userData = UserModel(
          email: email,
          username: username,
          phone: phone,
          address: address,
        );

        await _dbRef.child('users/$uid').set(userData.toJson());
      }

      return result.user;
    } catch (e) {
      print("Registration error: $e");
      return null;
    }
  }

  Future<UserModel?> fetchUserProfile(String uid) async {
    try {
      final snapshot = await _dbRef.child('users/$uid').get();
      if (snapshot.exists) {
        final raw = snapshot.value;

        if (raw is Map<Object?, Object?>) {
          final castedMap = raw.map(
            (key, value) => MapEntry(key.toString(), value),
          );

          if (castedMap['address'] is Map<Object?, Object?>) {
            castedMap['address'] =
                (castedMap['address'] as Map<Object?, Object?>).map(
                  (key, value) => MapEntry(key.toString(), value),
                );
          }

          return UserModel.fromJson(Map<String, dynamic>.from(castedMap));
        }
      }
    } catch (e) {
      print("Fetch profile error: $e");
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
