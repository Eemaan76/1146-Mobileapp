import 'package:flutter/material.dart';
import '../../core/constants.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get in Touch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('We are here to help you with any issues or queries.', style: TextStyle(color: AppConstants.grey)),
            SizedBox(height: 40),
            _buildContactCard(Icons.phone, 'Support Phone', '+92 300 1234567'),
            SizedBox(height: 16),
            _buildContactCard(Icons.email, 'Support Email', 'support@rentalpro.com'),
            SizedBox(height: 16),
            _buildContactCard(Icons.info, 'About Us', 'RentalPro is a leading property rental platform in Pakistan.'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryPurple),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
