import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    
    if (pickedFile != null) {
      try {
        await Provider.of<AuthProvider>(context, listen: false).updateProfilePicture(pickedFile.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated!'), backgroundColor: AppConstants.primaryPurple),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update picture.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: authProvider.isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _pickAndUploadImage(context),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppConstants.lightPurple,
                          backgroundImage: (user?.avatar != null && user!.avatar!.isNotEmpty)
                              ? (user.avatar!.startsWith('http')
                                  ? NetworkImage(user.avatar!) as ImageProvider
                                  : FileImage(File(user.avatar!)))
                              : null,
                          child: (user?.avatar == null || user!.avatar!.isEmpty)
                              ? Icon(Icons.person, size: 80, color: AppConstants.primaryPurple)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _pickAndUploadImage(context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryPurple,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 24),
            Text(user?.name ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(user?.email ?? '', style: TextStyle(color: AppConstants.grey)),
            SizedBox(height: 32),
            _buildInfoTile(Icons.phone, 'Phone', user?.phone ?? ''),
            _buildInfoTile(Icons.work, 'Role', user?.role ?? ''),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
              child: Text('Profile Settings'),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/contact-us'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Contact Us'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryPurple),
      title: Text(label, style: TextStyle(fontSize: 14, color: AppConstants.grey)),
      subtitle: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.black)),
    );
  }
}
