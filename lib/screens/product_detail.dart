import 'package:flutter/material.dart';
import 'package:mobile_final/widgets/comment_section.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../provider/global_provider.dart';

class Product_detail extends StatefulWidget {
  final ProductModel product;
  const Product_detail(this.product, {super.key});

  @override
  State<Product_detail> createState() => _Product_detailState();
}

class _Product_detailState extends State<Product_detail> {
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;

  void _loadComments() async {
    final provider = Provider.of<Global_provider>(context, listen: false);
    final comments = await provider.getComments(widget.product.id.toString());
    setState(() {
      _comments = comments;
      _isLoading = false;
    });
  }

  void _toggleFavorite() async {
    final provider = Provider.of<Global_provider>(context, listen: false);
    final success = await provider.toggleFavorite(widget.product);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to favorite items")),
      );
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Бүтээгдэхүүний дэлгэрэнгүй"),
        actions: [
          IconButton(
            icon: Icon(
              widget.product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.product.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final provider = Provider.of<Global_provider>(context, listen: false);
          final success = await provider.addCartItems(widget.product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? "Сагсанд нэмлээ!"
                    : "Сагсанд нэмэхийн тулд нэвтэрнэ үү",
              ),
            ),
          );
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.product.image!,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.product.category ?? '',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        widget.product.rating?.rate?.toStringAsFixed(1) ??
                            'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.product.title ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.description ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              '₹${widget.product.price!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CommentSection(
                    productId: widget.product.id.toString(),
                    initialComments: _comments,
                  ),
          ],
        ),
      ),
    );
  }
}
