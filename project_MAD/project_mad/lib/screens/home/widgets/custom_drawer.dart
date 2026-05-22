import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppConstants.primaryPurple),
            accountName: Text(user?.name ?? 'Guest'),
            accountEmail: Text(user?.email ?? 'Not logged in'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? '?',
                style: TextStyle(fontSize: 24, color: AppConstants.primaryPurple),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          if (user?.role == 'Landlord')
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('Add Property'),
              onTap: () => Navigator.pushNamed(context, '/add-property'),
            ),
          if (user?.role == 'Landlord')
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Show Listings'),
              onTap: () => Navigator.pushNamed(context, '/listings'),
            ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search Property'),
            onTap: () => Navigator.pushNamed(context, '/search'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () => Navigator.pushNamed(context, '/map'),
          ),
          Divider(),
          Spacer(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/auth');
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
