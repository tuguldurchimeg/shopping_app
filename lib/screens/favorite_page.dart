import 'package:flutter/material.dart';
import 'package:mobile_final/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:mobile_final/widgets/favorite_item.dart';
import 'package:mobile_final/models/product_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _isFirstLoad = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstLoad) {
      _isFirstLoad = false;
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    final provider = Provider.of<Global_provider>(context, listen: false);
    await provider.syncFavoritesFromFirebase();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleRemoveFavorite(ProductModel product) async {
    final provider = Provider.of<Global_provider>(context, listen: false);
    await provider.toggleFavorite(product);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.favorites),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<Global_provider>(
              builder: (context, provider, _) {
                final favorites = provider.products
                    .where((product) => product.isFavorite)
                    .toList();

                if (favorites.isEmpty) {
                  return Center(child: Text(t.noFavorites)); // ← localized
                }

                return ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (_, index) {
                    final item = favorites[index];
                    return FavoriteItem(
                      item: item,
                      onRemove: () => _handleRemoveFavorite(item),
                    );
                  },
                );
              },
            ),
    );
  }
}
