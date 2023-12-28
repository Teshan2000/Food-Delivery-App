import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Function() onProfilepressed;
  final Function() onCategoriesPressed;
  final Function() onFavoritesPressed;
  final Function() onCartPressed;
  final Function() onOrdersPressed;
  final Function() onLogoutPressed;

  const AppDrawer({
    super.key,
    required this.onProfilepressed,
    required this.onCategoriesPressed,
    required this.onFavoritesPressed,
    required this.onCartPressed,
    required this.onOrdersPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              accountName: Text(
                'Peter Parker',
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text('peterparker22@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('Assets/peter.jpg'),
              ),
              currentAccountPictureSize: Size.square(50),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Profile',
            ),
            onTap: onProfilepressed,
          ),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text(
              'Categories',
            ),
            onTap: onCategoriesPressed,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Favorites',
            ),
            onTap: onFavoritesPressed,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text(
              'Cart',
            ),
            onTap: onCartPressed,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text(
              'Orders',
            ),
            onTap: onOrdersPressed,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Logout',
            ),
            onTap: onLogoutPressed,
          ),
        ],
      ),
    );
  }
}
