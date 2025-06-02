import 'package:flutter/material.dart';
import 'package:mobile_final/l10n/app_localizations.dart';
import 'package:mobile_final/models/product_model.dart';
import 'package:mobile_final/screens/payment_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<ProductModel> cartItems;
  final double total;

  const CheckoutPage({super.key, required this.cartItems, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.proceedToCheckout),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🛒 Cart items
                  ...widget.cartItems.map(
                    (item) => Card(
                      child: ListTile(
                        leading: Image.network(
                          item.image!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(item.title ?? ''),
                        subtitle: Text("Qty: ${item.count}"),
                        trailing: Text(
                          "\$${(item.price! * item.count!).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionHeader(t.shippingAddress),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: t.enterAddress,
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 20),

                  _sectionHeader(t.paymentDetails),
                  _infoTile(
                    t.productPrice,
                    "\$${widget.total.toStringAsFixed(2)}",
                  ),
                  _infoTile(
                    t.totalCost,
                    "\$${widget.total.toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                if (addressController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(t.enterAddress)));
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentPage()),
                );
              },
              icon: const Icon(Icons.lock),
              label: Text(t.continueToPayment),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
