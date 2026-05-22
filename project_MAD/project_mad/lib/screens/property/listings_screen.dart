import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../core/constants.dart';
import 'property_detail_screen.dart';
import 'add_property_screen.dart';
class ListingsScreen extends StatefulWidget {
  @override
  _ListingsScreenState createState() => _ListingsScreenState();
}
class _ListingsScreenState extends State<ListingsScreen> {
  @override
  void initState() { // data recive for specific user
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser; // id of the current user 
    Future.microtask(() =>  // future .microtask means that when the screen load it frequntly fetch database  properties of that user 
      Provider.of<PropertyProvider>(context, listen: false).fetchUserProperties(user!.id!)
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);// connectionn of provider for data fetching
    return Scaffold(
      appBar: AppBar(title: Text('My Listings')),
      body: propertyProvider.isLoading 
        ? Center(child: CircularProgressIndicator())
        : propertyProvider.userProperties.isEmpty
          ? Center(child: Text('No listings found.'))
          : ListView.builder(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: propertyProvider.userProperties.length, // how many listing properties 
              itemBuilder: (context, index) {
                final p = propertyProvider.userProperties[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppConstants.lightPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: (p.imageBase64 != null && p.imageBase64!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(base64Decode(p.imageBase64!), fit: BoxFit.cover),
                          )
                        : Icon(
                            p.propertyType == 'Home' ? Icons.home : Icons.store, 
                            color: AppConstants.primaryPurple
                          ),
                    ),
                    title: Text(p.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('PKR ${p.price}\n${p.location}'),
                    trailing: PopupMenuButton(
                      onSelected: (val) {
                        if (val == 'edit') { // redirect to add property screen 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPropertyScreen(property: p),
                            ),
                          );
                        } else if (val == 'delete') {
                          propertyProvider.deleteProperty(p.id!);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PropertyDetailScreen(property: p)), // on tap redirect to details screen
                    ),
                  ),
                );
              },
            ),
    );
  }
}
