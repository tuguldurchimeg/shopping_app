import 'package:flutter/material.dart';
import 'package:mobile_final/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/provider/global_provider.dart';

class FavoriteItem extends StatelessWidget {
  final ProductModel item;
  final VoidCallback onRemove;

  const FavoriteItem({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Global_provider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text("Men's Clothing", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.price?.toStringAsFixed(2) ?? '0.00'}\$',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    final success = await provider.toggleFavorite(item);
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please log in to modify favorites."),
                        ),
                      );
                    } else {
                      onRemove();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
