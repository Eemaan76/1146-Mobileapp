import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/property_model.dart';
import '../../core/constants.dart';

class PropertyDetailScreen extends StatelessWidget {
  final PropertyModel property;

  PropertyDetailScreen({required this.property});

  void _launchCaller() async {
    final url = 'tel:${property.contact}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchWhatsApp() async {
    final url = 'whatsapp://send?phone=${property.contact}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: property.id!,
                child: (property.imageBase64 != null && property.imageBase64!.isNotEmpty)
                  ? Image.memory(base64Decode(property.imageBase64!), fit: BoxFit.cover)
                  : Container(
                      color: AppConstants.lightPurple,
                      child: Icon(Icons.home, size: 100, color: AppConstants.primaryPurple),
                    ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.lightPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          property.propertyType,
                          style: TextStyle(color: AppConstants.primaryPurple, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(property.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppConstants.grey),
                      SizedBox(width: 4),
                      Text(property.location, style: TextStyle(fontSize: 16, color: AppConstants.grey)),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      _buildSpecItem(Icons.square_foot, 'Area', property.areaSize),
                      SizedBox(width: 24),
                      _buildSpecItem(Icons.category, 'Type', property.subType),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(
                    property.description,
                    style: TextStyle(fontSize: 16, color: AppConstants.black.withOpacity(0.7), height: 1.5),
                  ),
                  SizedBox(height: 32),
                  Text('Landlord Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: AppConstants.lightPurple, child: Icon(Icons.person)),
                    title: Text('Landlord'),
                    subtitle: Text(property.email),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price', style: TextStyle(color: AppConstants.grey)),
                  Text('PKR ${property.price}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.primaryPurple)),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _launchCaller,
              icon: Icon(Icons.call),
              label: Text('Call'),
              style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _launchWhatsApp,
              icon: Icon(Icons.chat),
              label: Text('WhatsApp'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(120, 50),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppConstants.lightGrey, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppConstants.primaryPurple),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: AppConstants.grey, fontSize: 12)),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
