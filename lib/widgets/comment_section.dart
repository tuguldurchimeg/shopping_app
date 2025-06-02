import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/global_provider.dart';

class CommentSection extends StatefulWidget {
  final String productId;
  final List<Map<String, dynamic>> initialComments;

  const CommentSection({
    super.key,
    required this.productId,
    required this.initialComments,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _controller = TextEditingController();
  late List<Map<String, dynamic>> _comments;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _comments = widget.initialComments;
    _enrichComments();
  }

  Future<void> _enrichComments() async {
    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<Global_provider>(context, listen: false);
    for (var comment in _comments) {
      final userId = comment['userId'];
      if (userId != null) {
        final user = await provider.getUser(userId);
        comment['username'] = user?.username ?? 'Anonymous';
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = Provider.of<Global_provider>(context, listen: false);
    await provider.addComment(widget.productId, text);

    setState(() {
      _comments.insert(0, {
        'comment': text,
        'username': 'You',
        'timestamp': DateTime.now().toIso8601String(),
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),
        const Text("Comments", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),

        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ..._comments.map(
            (c) => Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(c['comment']),
                subtitle: Text(
                  '${c['username']} • ${c['timestamp']?.split("T")[0] ?? ''}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),

        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "Write a comment",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text("Post", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        ),
      ],
    );
  }
}
