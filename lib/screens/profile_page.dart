import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:mobile_final/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;
  const ProfilePage({super.key, this.onLocaleChange});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> promos = ["WELCOME10"];
  final List<String> paymentMethods = ["Visa - 1234"];

  void _addPromo() {
    setState(() {
      promos.add("PROMO${promos.length + 1}");
    });
  }

  void _addPaymentMethod() {
    setState(() {
      paymentMethods.add("New Card ****${1000 + paymentMethods.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Global_provider>(context);
    final user = provider.currentUser;
    final t = AppLocalizations.of(context)!;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              widget.onLocaleChange?.call(locale);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('en'), child: Text("English")),
              PopupMenuItem(value: Locale('mn'), child: Text("Монгол")),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade100,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(""),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        user.phone,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.editTapped)));
                  },
                  icon: const Icon(Icons.edit, color: Colors.grey),
                ),
              ],
            ),
          ),

          _sectionCardGroup(t.general, [
            CustomExpandableTile(
              icon: Icons.local_shipping,
              title: t.shippingAddresses,
              items: [
                "${user.address.number} ${user.address.street}, ${user.address.city}",
              ],
            ),
            CustomExpandableTile(
              icon: Icons.discount,
              title: t.promotionCodes,
              items: promos,
              onAdd: _addPromo,
            ),
            CustomExpandableTile(
              icon: Icons.payment,
              title: t.paymentMethod,
              items: paymentMethods,
              onAdd: _addPaymentMethod,
            ),
          ]),

          const SizedBox(height: 24),
          _expansionTile(t.myOrders),
          _expansionTile(t.myReviews),
          _expansionTile(t.settings),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: () async {
              final provider = Provider.of<Global_provider>(
                context,
                listen: false,
              );
              await provider.logout();
              provider.changeCurrentIdx(0);

              if (!mounted) return;
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            icon: const Icon(Icons.logout),
            label: Text(t.logout),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionCardGroup(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _expansionTile(String title) {
    final t = AppLocalizations.of(context)!;
    return ExpansionTile(
      title: Text(title),
      children: [ListTile(title: Text(t.comingSoon))],
    );
  }
}

class CustomExpandableTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final VoidCallback? onAdd;

  const CustomExpandableTile({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
    this.onAdd,
  });

  @override
  State<CustomExpandableTile> createState() => _CustomExpandableTileState();
}

class _CustomExpandableTileState extends State<CustomExpandableTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.icon, color: Colors.blueGrey),
            title: Text(widget.title),
            trailing: IconButton(
              icon: Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                ...widget.items.map(
                  (e) => ListTile(
                    title: Text(e),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        setState(() {
                          widget.items.remove(e);
                        });
                      },
                    ),
                  ),
                ),
                if (widget.onAdd != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextButton.icon(
                      onPressed: widget.onAdd,
                      icon: const Icon(Icons.add),
                      label: Text(t.addNew),
                    ),
                  ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
