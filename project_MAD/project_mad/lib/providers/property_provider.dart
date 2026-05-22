import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property_model.dart';
import '../core/constants.dart';

class PropertyProvider with ChangeNotifier {
  List<PropertyModel> _properties = [];
  List<PropertyModel> _userProperties = [];
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'rentelapp');

  List<PropertyModel> get properties => _properties;
  List<PropertyModel> get userProperties => _userProperties;
  bool get isLoading => _isLoading;

  Future<void> fetchAllProperties() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final snapshot = await _firestore.collection(AppConstants.propertyCollection).get();
      _properties = snapshot.docs
          .map((doc) => PropertyModel.fromMap(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      print('Error fetching properties: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserProperties(String landlordId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final snapshot = await _firestore
          .collection(AppConstants.propertyCollection)
          .where('landlordId', isEqualTo: landlordId)
          .get();
      _userProperties = snapshot.docs
          .map((doc) => PropertyModel.fromMap(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      print('Error fetching user properties: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProperty(PropertyModel property) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final map = property.toMap();
      print('Posting Property Data: $map');
      await _firestore.collection(AppConstants.propertyCollection).add(map);
      await fetchAllProperties();
      await fetchUserProperties(property.landlordId);
    } catch (e) {
      print('Error adding property: $e');
      rethrow; // Important: pass the error to the UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProperty(PropertyModel property) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore
          .collection(AppConstants.propertyCollection)
          .doc(property.id)
          .update(property.toMap());
      await fetchAllProperties();
      await fetchUserProperties(property.landlordId);
    } catch (e) {
      print('Error updating property: $e');
      rethrow; // Important: pass the error to the UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProperty(String id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore.collection(AppConstants.propertyCollection).doc(id).delete();
      await fetchAllProperties();
    } catch (e) {
      print('Error deleting property: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<PropertyModel> searchProperties({
    String? query,
    String? type,
    double? minPrice,
    double? maxPrice,
    String? areaSize,
  }) {
    return _properties.where((p) {
      final matchesQuery = query == null || 
          p.title.toLowerCase().contains(query.toLowerCase()) || 
          p.location.toLowerCase().contains(query.toLowerCase());
      final matchesType = type == null || p.propertyType == type;
      final matchesPrice = (minPrice == null || p.price >= minPrice) && 
                           (maxPrice == null || p.price <= maxPrice);
      final matchesArea = areaSize == null || p.areaSize == areaSize;
      
      return matchesQuery && matchesType && matchesPrice && matchesArea;
    }).toList();
  }
}
