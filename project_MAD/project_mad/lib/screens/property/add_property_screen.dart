import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../models/property_model.dart';
import '../../core/constants.dart';

class AddPropertyScreen extends StatefulWidget {
  final PropertyModel? property;
  const AddPropertyScreen({Key? key, this.property}) : super(key: key);

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _propertyType;
  late String _subType;
  late String _areaSize;
  File? _imageFile;
  final _picker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _propertyType = widget.property?.propertyType ?? 'Home';
    _subType = widget.property?.subType ?? 'Full House';
    _areaSize = widget.property?.areaSize ?? '5 Marla';
    _titleController = TextEditingController(text: widget.property?.title ?? '');
    _descController = TextEditingController(text: widget.property?.description ?? '');
    _locationController = TextEditingController(text: widget.property?.location ?? '');
    _priceController = TextEditingController(text: widget.property?.price.toString() ?? '');
    _contactController = TextEditingController(text: widget.property?.contact ?? '');
    _emailController = TextEditingController(text: widget.property?.email ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > 800000) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image is too large! Please pick a smaller photo.'), backgroundColor: Colors.red));
         return;
      }
      setState(() => _imageFile = file);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    String? base64Image;
    if (_imageFile != null) {
      base64Image = base64Encode(_imageFile!.readAsBytesSync());
    }

    if (user?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: User not logged in.'), backgroundColor: Colors.red));
      return;
    }

    final property = PropertyModel(
      id: widget.property?.id, // Keep the same ID if editing
      landlordId: user!.id!,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      propertyType: _propertyType,
      subType: _subType,
      areaSize: _areaSize,
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      contact: _contactController.text.trim(),
      email: _emailController.text.trim(),
      imageBase64: (base64Image != null && base64Image.isNotEmpty) ? base64Image : widget.property?.imageBase64,
    );

    try {
      if (widget.property == null) {
        await Provider.of<PropertyProvider>(context, listen: false).addProperty(property);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Property Posted Successfully!')));
      } else {
        await Provider.of<PropertyProvider>(context, listen: false).updateProperty(property);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Property Updated Successfully!')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.property == null ? 'Add Property' : 'Edit Property')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Property Type', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio(
                    value: 'Home', 
                    groupValue: _propertyType, 
                    onChanged: (v) => setState(() {
                      _propertyType = v.toString();
                      _subType = 'Full House'; 
                      _areaSize = '5 Marla'; // Reset area
                    })
                  ),
                  Text('Home'),
                  Radio(
                    value: 'Shop', 
                    groupValue: _propertyType, 
                    onChanged: (v) => setState(() {
                      _propertyType = v.toString();
                      _subType = 'Full Shop'; 
                      _areaSize = '1 Marla'; // Reset area
                    })
                  ),
                  Text('Shop'),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _subType,
                items: (_propertyType == 'Home' 
                  ? ['Full House', 'Upper Portion', 'Lower Portion'] 
                  : ['Full Shop'])
                  .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _subType = v!),
              ),
              SizedBox(height: 16),
              TextFormField(controller: _titleController, decoration: InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              SizedBox(height: 16),
              TextFormField(controller: _descController, decoration: InputDecoration(labelText: 'Description'), maxLines: 3),
              SizedBox(height: 16),
              TextFormField(controller: _locationController, decoration: InputDecoration(labelText: 'Location'), validator: (v) => v!.isEmpty ? 'Required' : null),
              SizedBox(height: 16),
              TextFormField(controller: _priceController, decoration: InputDecoration(labelText: 'Price (PKR)'), keyboardType: TextInputType.number),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _areaSize,
                items: (_propertyType == 'Home' ? ['5 Marla', '7 Marla', '10 Marla'] : ['1 Marla', '2 Marla', '3 Marla', '4 Marla', '5 Marla'])
                  .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _areaSize = v!),
                decoration: InputDecoration(labelText: 'Area Size'),
              ),
              SizedBox(height: 16),
              TextFormField(controller: _contactController, decoration: InputDecoration(labelText: 'Contact Number')),
              SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 24),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppConstants.lightGrey, borderRadius: BorderRadius.circular(16)),
                  child: _imageFile != null 
                    ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_imageFile!, fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.add_a_photo, size: 40, color: AppConstants.grey), Text('Upload Property Image')],
                      ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit, 
                child: Text(widget.property == null ? 'Post Property' : 'Update Property')
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
