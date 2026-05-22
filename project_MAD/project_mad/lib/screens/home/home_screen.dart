import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';
import '../../core/constants.dart';
import 'widgets/custom_drawer.dart';
import '../property/property_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedType = 'Home';
  String _selectedSubtype = 'Full House';
  String _selectedArea = '5 Marla';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<PropertyProvider>(context, listen: false).fetchAllProperties()
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final propertyProvider = Provider.of<PropertyProvider>(context);

    final filteredProperties = propertyProvider.properties.where((p) {
      return p.propertyType == _selectedType && 
             p.subType == _selectedSubtype && 
             p.areaSize == _selectedArea;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          CircleAvatar(
            backgroundColor: AppConstants.lightPurple,
            child: Icon(Icons.person, color: AppConstants.primaryPurple),
          ),
          SizedBox(width: 16),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search properties...',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchScreen(initialQuery: val),
                      ),
                    );
                  }
                },
              ),
            ),

            // Property Type Selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Row(
                children: [
                  _buildTypeChip('Home'),
                  SizedBox(width: 10),
                  _buildTypeChip('Shop'),
                ],
              ),
            ),

            // Subtype Selector
            if (_selectedType == 'Home')
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: Row(
                  children: [
                    _buildSubtypeChip('Full House'),
                    _buildSubtypeChip('Upper Portion'),
                    _buildSubtypeChip('Lower Portion'),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: _buildSubtypeChip('Full Shop'),
              ),

            // Area Selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Text('Select Area Size', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: (_selectedType == 'Home' 
                  ? ['5 Marla', '7 Marla', '10 Marla'] 
                  : ['1 Marla', '2 Marla', '3 Marla', '4 Marla', '5 Marla'])
                  .map((area) => _buildAreaChip(area)).toList(),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Text('Featured Properties', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

            propertyProvider.isLoading 
              ? Center(child: CircularProgressIndicator())
              : filteredProperties.isEmpty
                ? Center(child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('No properties found for this selection.'),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      final p = filteredProperties[index];
                      return _buildPropertyCard(p);
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: user?.role == 'Landlord' 
        ? FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/add-property'),
            child: Icon(Icons.add),
            backgroundColor: AppConstants.primaryPurple,
          )
        : null,
    );
  }

  Widget _buildTypeChip(String type) {
    bool isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(type),
      selected: isSelected,
      onSelected: (val) => setState(() {
        _selectedType = type;
        _selectedSubtype = type == 'Home' ? 'Full House' : 'Full Shop';
        _selectedArea = type == 'Home' ? '5 Marla' : '1 Marla';
      }),
      selectedColor: AppConstants.primaryPurple,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  Widget _buildSubtypeChip(String subtype) {
    bool isSelected = _selectedSubtype == subtype;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(subtype),
        selected: isSelected,
        onSelected: (val) => setState(() => _selectedSubtype = subtype),
        selectedColor: AppConstants.accentPurple,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildAreaChip(String area) {
    bool isSelected = _selectedArea == area;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(area),
        onPressed: () => setState(() => _selectedArea = area),
        backgroundColor: isSelected ? AppConstants.primaryPurple : AppConstants.lightGrey,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildPropertyCard(dynamic property) {
    return InkWell(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => PropertyDetailScreen(property: property))
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Hero(
                tag: property.id!,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: AppConstants.lightPurple,
                  child: (property.imageBase64 != null && property.imageBase64!.isNotEmpty)
                    ? Image.memory(base64Decode(property.imageBase64!), fit: BoxFit.cover)
                    : Icon(Icons.home, size: 80, color: AppConstants.primaryPurple),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppConstants.grey),
                      SizedBox(width: 4),
                      Text(property.location, style: TextStyle(color: AppConstants.grey)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('PKR ${property.price}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.primaryPurple)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
