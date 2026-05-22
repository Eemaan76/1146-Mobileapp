import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../providers/property_provider.dart';
import '../../core/constants.dart';
import '../../models/property_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  String _searchQuery = "";
  LatLng? _searchedLocation;
  String? _searchedLocationName;
  PropertyModel? _selectedProperty;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Rebuild to update border color
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchProperty(String query, PropertyProvider provider) async {
    if (query.isEmpty) return;

    setState(() {
      _searchQuery = query.toLowerCase();
      _isLoading = true;
      _selectedProperty = null; // Clear selected property
      _searchedLocation = null; // Clear previous search
    });

    // 1. Search in local database properties first
    final found = provider.properties.where((p) => 
      p.title.toLowerCase().contains(_searchQuery) || 
      p.location.toLowerCase().contains(_searchQuery)
    ).toList();

    if (found.isNotEmpty) {
      final p = found.first;
      // Use coordinates if available, otherwise fallback to the price-based scatter formula
      final target = p.coordinates != null 
          ? LatLng(p.coordinates!['latitude']!, p.coordinates!['longitude']!)
          : LatLng(31.4504 + (p.price / 5000000) * 0.1, 73.1350 + (p.price / 5000000) * 0.1);
      
      setState(() {
        _selectedProperty = p;
        _isLoading = false;
      });
      _mapController.move(target, 15);
      return;
    }

    // 2. If not found in database, clear search state and show SnackBar
    if (!mounted) return;
    setState(() {
      _searchQuery = ""; // Reset search query so no markers show
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('There is no such listing in that location'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _handleMapTap(LatLng point) async {
    setState(() {
      _searchedLocation = point;
      _searchedLocationName = "Fetching address...";
      _selectedProperty = null; // Clear selected property
      _isLoading = true;
    });

    try {
      final url = 'https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json&accept-language=en';
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'RentalPro_App/1.0 (com.example.project_mad)'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        if (data.isNotEmpty && data['display_name'] != null) {
          setState(() {
            _searchedLocationName = data['display_name'];
          });
        } else {
          setState(() {
            _searchedLocationName = "Coordinates: ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}";
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          _searchedLocationName = "Coordinates: ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}";
        });
      }
    } catch (e) {
      debugPrint("Reverse Geocode Error: $e");
      if (!mounted) return;
      setState(() {
        _searchedLocationName = "Coordinates: ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    
    // Filter markers based on search query (if searching local properties)
    List<Marker> markers = [];
    if (_searchQuery.isNotEmpty) {
      markers = propertyProvider.properties
        .where((p) => 
          p.title.toLowerCase().contains(_searchQuery) || 
          p.location.toLowerCase().contains(_searchQuery))
        .map((p) {
        final point = p.coordinates != null
            ? LatLng(p.coordinates!['latitude']!, p.coordinates!['longitude']!)
            : LatLng(31.4504 + (p.price / 5000000) * 0.1, 73.1350 + (p.price / 5000000) * 0.1);
        
        final isSelected = _selectedProperty?.id == p.id;
        
        return Marker(
          point: point,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedProperty = p;
                _searchedLocation = null; // Clear search location
              });
              _mapController.move(point, 15);
            },
            child: Icon(
              Icons.location_on,
              color: isSelected ? Colors.orange : AppConstants.primaryPurple,
              size: isSelected ? 48 : 40,
            ),
          ),
        );
      }).toList();
    }

    // Add searched location marker
    if (_searchedLocation != null) {
      markers.add(
        Marker(
          point: _searchedLocation!,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              _mapController.move(_searchedLocation!, 15);
            },
            child: Icon(
              Icons.location_on,
              color: Colors.redAccent,
              size: 48,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Property Map'),
        actions: [
          if (_searchedLocation != null || _selectedProperty != null)
            IconButton(
              icon: Icon(Icons.clear_all),
              tooltip: 'Clear Markers',
              onPressed: () {
                setState(() {
                  _searchedLocation = null;
                  _searchedLocationName = null;
                  _selectedProperty = null;
                  _searchController.clear();
                  _searchQuery = "";
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(31.4504, 73.1350), // Faisalabad coordinates
              initialZoom: 12,
              onTap: (tapPosition, point) => _handleMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.project_mad',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          
          // Floating Search Bar & Linear Loader
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  height: 55,
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.only(left: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _focusNode.hasFocus ? AppConstants.primaryPurple : Colors.black12,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08), 
                        blurRadius: 10, 
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Search properties or cities (e.g. Lahore)...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (val) => _searchProperty(val, propertyProvider),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _searchProperty(_searchController.text, propertyProvider),
                        child: Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryPurple),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Searched Custom Location Bottom Card
          if (_searchedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.pin_drop, color: Colors.redAccent, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "Custom Location",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppConstants.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                _searchedLocation = null;
                                _searchedLocationName = null;
                              });
                            },
                          )
                        ],
                      ),
                      Divider(height: 8),
                      SizedBox(height: 8),
                      Text(
                        _searchedLocationName ?? "Loading Address...",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Lat: ${_searchedLocation!.latitude.toStringAsFixed(5)}, Lon: ${_searchedLocation!.longitude.toStringAsFixed(5)}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _mapController.move(_searchedLocation!, 15);
                              },
                              icon: Icon(Icons.my_location, size: 16),
                              label: Text("Center"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppConstants.primaryPurple,
                                side: BorderSide(color: AppConstants.primaryPurple),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_searchedLocationName != null) {
                                  Clipboard.setData(ClipboardData(text: _searchedLocationName!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Address copied to clipboard!')),
                                  );
                                }
                              },
                              icon: Icon(Icons.copy, size: 16),
                              label: Text("Copy"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Selected Property Card Details
          if (_selectedProperty != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  _selectedProperty!.propertyType == 'Home' ? Icons.home : Icons.store,
                                  color: AppConstants.primaryPurple,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _selectedProperty!.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppConstants.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                _selectedProperty = null;
                              });
                            },
                          )
                        ],
                      ),
                      Divider(height: 8),
                      SizedBox(height: 8),
                      Text(
                        'Location: ${_selectedProperty!.location}',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PKR ${_selectedProperty!.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryPurple,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConstants.lightPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_selectedProperty!.areaSize} | ${_selectedProperty!.subType}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                final point = _selectedProperty!.coordinates != null
                                    ? LatLng(_selectedProperty!.coordinates!['latitude']!, _selectedProperty!.coordinates!['longitude']!)
                                    : LatLng(31.4504 + (_selectedProperty!.price / 5000000) * 0.1, 73.1350 + (_selectedProperty!.price / 5000000) * 0.1);
                                _mapController.move(point, 16);
                              },
                              icon: Icon(Icons.zoom_in, size: 16),
                              label: Text("Zoom In"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppConstants.primaryPurple,
                                side: BorderSide(color: AppConstants.primaryPurple),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  builder: (ctx) => Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Contact Info',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.primaryPurple),
                                        ),
                                        SizedBox(height: 12),
                                        ListTile(
                                          leading: Icon(Icons.phone, color: AppConstants.primaryPurple),
                                          title: Text('Phone: ${_selectedProperty!.contact}'),
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(text: _selectedProperty!.contact));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Phone number copied!')),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email, color: AppConstants.primaryPurple),
                                          title: Text('Email: ${_selectedProperty!.email}'),
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(text: _selectedProperty!.email));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Email address copied!')),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.contact_phone, size: 16),
                              label: Text("Contact Seller"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
