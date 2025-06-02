import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/screens/product_detail.dart';
import '../models/product_model.dart';
import '../provider/global_provider.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {super.key});

  _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Product_detail(data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, _) {
        final current = provider.products.firstWhere(
          (p) => p.id == data.id,
          orElse: () => data,
        );

        return InkWell(
          onTap: () => _onTap(context),
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(current.image ?? ''),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          current.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: current.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          final success = await provider.toggleFavorite(
                            current,
                          );
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please log in to favorite items",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current.title ?? '',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        '\$${current.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            current.category ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  current.rating?.rate?.toStringAsFixed(1) ??
                                      'N/A',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
