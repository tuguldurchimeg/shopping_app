import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_final/models/user.dart';

Future<UserModel?> fetchUserProfile(String uid) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('users/$uid').get();

  if (snapshot.exists) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return UserModel.fromJson(data);
  } else {
    return null;
  }
}
