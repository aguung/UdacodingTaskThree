import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  String id;
  String name;
  String address;
  String description;
  String latitude;
  String longitude;
  DateTime updateAt;

  Hospital(
      {this.id,
      this.name,
      this.address,
      this.description,
      this.latitude,
      this.longitude,
      this.updateAt});

  Hospital.fromMap(DocumentSnapshot snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        address = snapshot['address'] ?? '',
        description = snapshot['description'] ?? '',
        latitude = snapshot['latitude'] ?? '',
        longitude = snapshot['longitude'] ?? '',
        updateAt = snapshot['updateAt'].toDate();

  toJson() {
    return {
      "name": name,
      "address": address,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "updateAt": updateAt,
    };
  }
}
