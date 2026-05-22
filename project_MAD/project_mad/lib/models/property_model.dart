class PropertyModel {
  final String? id;
  final String landlordId;
  final String title;
  final String description;
  final String location;
  final String propertyType; // 'Home' or 'Shop'
  final String subType; // 'Full House', 'Upper Portion', 'Lower Portion', 'Full Shop'
  final String areaSize;
  final double price;
  final String contact;
  final String email;
  final String? imageBase64;
  final Map<String, double>? coordinates;

  PropertyModel({
    this.id,
    required this.landlordId,
    required this.title,
    required this.description,
    required this.location,
    required this.propertyType,
    required this.subType,
    required this.areaSize,
    required this.price,
    required this.contact,
    required this.email,
    this.imageBase64,
    this.coordinates,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'landlordId': landlordId,
      'title': title,
      'description': description,
      'location': location,
      'propertyType': propertyType,
      'subType': subType,
      'areaSize': areaSize,
      'price': price,
      'contact': contact,
      'email': email,
    };
    if (imageBase64 != null) map['imageBase64'] = imageBase64;
    if (coordinates != null) map['coordinates'] = coordinates;
    return map;
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return PropertyModel(
      id: docId ?? map['id'],
      landlordId: map['landlordId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      propertyType: map['propertyType'] ?? 'Home',
      subType: map['subType'] ?? '',
      areaSize: map['areaSize'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      imageBase64: map['imageBase64'],
      coordinates: map['coordinates'] != null 
          ? Map<String, double>.from(map['coordinates']) 
          : null,
    );
  }
}
