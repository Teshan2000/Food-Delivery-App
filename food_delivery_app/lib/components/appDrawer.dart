import 'package:flutter/material.dart';

class Appdrawer extends StatelessWidget {
  const Appdrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: Widget[
          UserAccountsDrawerHeader(
            accountName: accountName,
            accountEmail: accountEmail
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: onProfilePressed,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: onProfilePressed,
          ),
        ],
      ),
    );
  }
}