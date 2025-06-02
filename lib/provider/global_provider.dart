import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_final/repository/repository.dart';
import '../models/product_model.dart';
import '../models/user.dart';

class Global_provider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final _storage = const FlutterSecureStorage();

  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  int currentIdx = 0;
  Locale get locale => _locale;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<bool> get isLoggedIn async => _auth.currentUser != null;

  Locale _locale = const Locale('mn');

  void changeLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    loadCartFromFirebase();
    notifyListeners();
  }

  void setProducts(List<ProductModel> data) {
    products = data;
    notifyListeners();
  }

  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _storage.delete(key: 'token');
    _currentUser = null;
    cartItems.clear();
    notifyListeners();
  }

  Future<void> syncCartToFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final cartRef = _db.child("users/${user.uid}/cart");
    final Map<String, dynamic> cartData = {
      for (var item in cartItems)
        item.id.toString(): {
          'id': item.id,
          'title': item.title,
          'price': item.price,
          'image': item.image,
          'count': item.count,
          'category': item.category,
        },
    };

    await cartRef.set(cartData);
  }

  Future<bool> addCartItems(ProductModel item) async {
    if (_auth.currentUser == null) return false;

    final existingIndex = cartItems.indexWhere((i) => i.id == item.id);
    if (existingIndex != -1) {
      cartItems.removeAt(existingIndex);
    } else {
      item.count = item.count ?? 1;
      cartItems.add(item);
    }

    await syncCartToFirebase();
    notifyListeners();
    return true;
  }

  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      syncCartToFirebase();
      notifyListeners();
    }
  }

  void increaseCount(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index].count = (cartItems[index].count ?? 1) + 1;
      syncCartToFirebase();
      notifyListeners();
    }
  }

  void decreaseCount(int index) {
    if (index >= 0 && index < cartItems.length) {
      if ((cartItems[index].count ?? 1) > 1) {
        cartItems[index].count = cartItems[index].count! - 1;
        syncCartToFirebase();
        notifyListeners();
      }
    }
  }

  Future<List<ProductModel>> syncFavoritesFromFirebase() async {
    final favIds = await MyRepository().fetchFavoriteIds();
    products = products.map((p) {
      p.isFavorite = favIds.contains(p.id);
      return p;
    }).toList();
    notifyListeners();
    return products.where((p) => p.isFavorite).toList();
  }

  Future<bool> toggleFavorite(ProductModel product) async {
    final success = await MyRepository().toggleFavorite(product);
    if (success) {
      product.isFavorite = !product.isFavorite;
      notifyListeners();
    }
    return success;
  }

  Future<void> addComment(String productId, String comment) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final commentRef = _db.child("comments/$productId").push();
    await commentRef.set({
      'userId': user.uid,
      'comment': comment,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getComments(String productId) async {
    final snapshot = await _db.child("comments/$productId").get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final result = <Map<String, dynamic>>[];

    final rawData = snapshot.value;
    if (rawData is Map) {
      rawData.forEach((key, value) {
        if (value is Map) {
          result.add(Map<String, dynamic>.from(value));
        }
      });
    }
    return result;
  }

  Future<void> loadCartFromFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _db.child("users/${user.uid}/cart").get();
    if (!snapshot.exists) return;

    final rawCart = snapshot.value;
    if (rawCart is Map<Object?, Object?>) {
      final items = <ProductModel>[];
      rawCart.forEach((key, value) {
        if (value is Map<Object?, Object?>) {
          final product = ProductModel.fromJson(
            Map<String, dynamic>.from(value as Map),
          );
          items.add(product);
        }
      });

      cartItems = items;
      notifyListeners();
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _db.child("users/$uid").get();
    if (snapshot.exists && snapshot.value is Map) {
      final raw = snapshot.value as Map<Object?, Object?>;
      final data = <String, dynamic>{};
      raw.forEach((key, value) {
        data[key.toString()] = value;
      });

      return UserModel.fromJson(data);
    }
    return null;
  }
}
