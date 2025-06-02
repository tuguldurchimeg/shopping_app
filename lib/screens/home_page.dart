import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_final/provider/global_provider.dart';
import 'package:mobile_final/screens/bags_page.dart';
import 'package:mobile_final/screens/shop_page.dart';
import 'package:mobile_final/screens/favorite_page.dart';
import 'package:mobile_final/screens/profile_page.dart';
import 'package:mobile_final/screens/login_page.dart';
import 'package:mobile_final/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final firebaseUser = snapshot.data;
            final isLoggedIn = firebaseUser != null;
            List<Widget> pages = [
              const ShopPage(),
              const BagsPage(),
              const FavoritePage(),
              isLoggedIn
                  ? ProfilePage(onLocaleChange: provider.changeLocale)
                  : const LoginScreen(),
            ];

            return Scaffold(
              body: pages[provider.currentIdx],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: provider.currentIdx,
                onTap: provider.changeCurrentIdx,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.shop),
                    label: t.shopping,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.shopping_basket),
                    label: t.myBag,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite),
                    label: t.favorites,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    label: t.profile,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
