import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_final/models/product_model.dart';

class MyRepository {
  // Fetch products from external API
  Future<List<ProductModel>?> fetchProductsData() async {
    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        return ProductModel.fromList(jsonDecode(response.body));
      } else {
        print("Failed to fetch products: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching products: $e");
    }
    return null;
  }

  Future<void> addComment(String productId, String comment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final commentRef = FirebaseDatabase.instance
        .ref("comments/$productId")
        .push();

    await commentRef.set({
      'userId': user.uid,
      'comment': comment,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getComments(String productId) async {
    final db = FirebaseDatabase.instance.ref();
    final snapshot = await db.child("comments/$productId").get();

    if (!snapshot.exists || snapshot.value == null) return [];

    final result = <Map<String, dynamic>>[];

    if (snapshot.value is Map) {
      (snapshot.value as Map).forEach((key, value) {
        if (value is Map) {
          result.add(Map<String, dynamic>.from(value));
        }
      });
    }

    return result;
  }

  Future<bool> toggleFavorite(ProductModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final ref = FirebaseDatabase.instance.ref(
      "users/${user.uid}/favorites/fav_${product.id}",
    );

    if (product.isFavorite) {
      await ref.remove();
    } else {
      await ref.set(true);
    }

    return true;
  }

  Future<Set<int>> fetchFavoriteIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final snapshot = await FirebaseDatabase.instance
        .ref("users/${user.uid}/favorites")
        .get();

    final favorites = <int>{};

    if (snapshot.exists && snapshot.value is Map) {
      (snapshot.value as Map).forEach((key, value) {
        if (value == true && key.toString().startsWith('fav_')) {
          final idStr = key.toString().replaceFirst('fav_', '');
          final id = int.tryParse(idStr);
          if (id != null) favorites.add(id);
        }
      });
    }

    return favorites;
  }
}
