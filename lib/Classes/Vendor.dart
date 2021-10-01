import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vendor {
  final String name;
  final String email;
  final int phno;
  final double price;
  final int quantity;
  final LatLng location;
  final String address;
  final int avatarCode;
  final double rating;
  final int supplied;
  final int totalRatings;

  Vendor(
      {this.name,
      this.totalRatings,
      this.rating,
      this.supplied,
      this.price,
      this.email,
      this.quantity,
      this.phno,
      this.location,
      this.address,
      this.avatarCode});
}
