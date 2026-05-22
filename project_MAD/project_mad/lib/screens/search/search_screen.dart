import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../core/constants.dart';
import '../property/property_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  SearchScreen({this.initialQuery});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _query;
  String? _selectedType;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedArea;

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final results = propertyProvider.searchProperties(
      query: _query,
      type: _selectedType,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      areaSize: _selectedArea,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Search Properties')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by location or title',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
          ),
          ExpansionTile(
            title: Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      hint: Text('Property Type'),
                      items: ['Home', 'Shop'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() {
                        _selectedType = val;
                        _selectedArea = null; // Reset area to avoid crash
                      }),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Min Price', prefixText: 'PKR '),
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => _minPrice = double.tryParse(val)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Max Price', prefixText: 'PKR '),
                            keyboardType: TextInputType.number,
                            onChanged: (val) => setState(() => _maxPrice = double.tryParse(val)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedArea,
                      hint: Text('Area Size'),
                      items: (_selectedType == 'Home' 
                          ? ['5 Marla', '7 Marla', '10 Marla'] 
                          : ['1 Marla', '2 Marla', '3 Marla', '4 Marla', '5 Marla'])
                          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setState(() => _selectedArea = val),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final p = results[index];
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PropertyDetailScreen(property: p)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
