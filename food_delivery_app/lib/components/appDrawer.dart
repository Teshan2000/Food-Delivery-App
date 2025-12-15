import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';

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
    double height = ScreenSize.height(context);
    
    return Drawer(
      backgroundColor: Colors.white,
      width: 320, 
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: height * 0.02,),
                CircleAvatar(
                  backgroundImage: AssetImage('Assets/peter.jpg'),
                  radius: 30,
                ),
                SizedBox(height: height * 0.2,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Peter Parker',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'peterparker22@gmail.com',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Icon(Icons.person),
            ),
            title: const Text(
              'Profile',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onProfilepressed,
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Icon(Icons.fastfood),
            ),
            title: const Text(
              'Categories',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onCategoriesPressed,
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Icon(Icons.favorite),
            ),
            title: const Text(
              'Favorites',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onFavoritesPressed,
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Icon(Icons.shopping_cart),
            ),
            title: const Text(
              'Cart',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onCartPressed,
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Icon(Icons.shopping_bag),
            ),
            title: const Text(
              'Orders',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onOrdersPressed,
          ),
          const SizedBox(height: 150),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Icon(Icons.exit_to_app),
            ),
            title: const Text(
              'Logout',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onLogoutPressed,
          ),
        ],
      ),
    );
  }
}
