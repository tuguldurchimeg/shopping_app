import 'package:flutter/material.dart';
import 'package:mobile_final/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:mobile_final/screens/checkout_page.dart';
import 'package:mobile_final/widgets/bag_item.dart';

class BagsPage extends StatelessWidget {
  const BagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        final cart = provider.cartItems;
        final total = cart.fold(
          0.0,
          (sum, item) => sum + (item.price! * item.count!),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(t.myBag), // Localized
            backgroundColor: Colors.blueAccent,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (_, index) => BagItem(
                    item: cart[index],
                    onAdd: () => provider.increaseCount(index),
                    onRemove: () => provider.decreaseCount(index),
                    onDelete: () => provider.removeItem(index),
                  ),
                ),
              ),
              const Divider(),
              // Total
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.totalAmount, style: const TextStyle(fontSize: 16)),
                    Text(
                      '${total.toStringAsFixed(2)}\$',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Checkout button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    t.checkout.toUpperCase(),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(
                          cartItems: List.from(provider.cartItems),
                          total: total,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
