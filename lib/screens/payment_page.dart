import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = "cash";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment methods"), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(""),
                _selectTile("Cash", "cash", Icons.wallet),
                _selectTile("Wallet", "wallet", Icons.account_balance_wallet),
                const Divider(thickness: 1),
                _sectionTitle("Add a credit card"),
                _selectTile("Add card", "card", Icons.credit_card),
                const Divider(thickness: 1),
                _sectionTitle("More payment options"),
                _selectTile("PayPal", "paypal", Icons.payment),
                _selectTile("Apple Pay", "apple", Icons.apple),
                _selectTile("Google Pay", "google", Icons.android),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle final payment action here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Paid using: $selectedMethod')),
                );
              },
              icon: const Icon(Icons.lock),
              label: const Text("Payment confirmation"),
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _selectTile(String title, String value, IconData icon) {
    final bool isSelected = selectedMethod == value;
    return InkWell(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border:
              Border.all(color: isSelected ? Colors.red : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.red.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.red : Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.red : Colors.black,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedMethod,
              onChanged: (v) => setState(() => selectedMethod = v!),
              activeColor: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
