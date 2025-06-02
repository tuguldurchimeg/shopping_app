import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/models/product_model.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:mobile_final/repository/repository.dart';
import '../widgets/product_view.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late Future<List<ProductModel>?> _future;

  @override
  void initState() {
    super.initState();
    _future = getProductsData();
  }

  Future<List<ProductModel>?> getProductsData() async {
    List<ProductModel>? data = await MyRepository().fetchProductsData();
    if (data != null) {
      final provider = Provider.of<Global_provider>(context, listen: false);
      provider.setProducts(data);
      await provider.syncFavoritesFromFirebase();
      return provider.products;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>?>(
      future: _future,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Бараанууд",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(223, 37, 37, 37),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => ProductViewShop(snapshot.data![index]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading products'));
        } else {
          return Center(child: Text('No products found'));
        }
      }),
    );
  }
}
