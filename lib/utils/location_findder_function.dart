import 'package:geocoding/geocoding.dart';

import '../model/LocationLatiLong.dart';

Future<Locationlatilong?> getLatLngFromAddress({
  required String street,
  required String city,
  required String state,
  required String country,
  required String postalCode,
}) async {
  try {
    final fullAddress =
        "$street, $city, $state, $postalCode, $country";

    final locations = await locationFromAddress(fullAddress);

    if (locations.isNotEmpty) {
      return Locationlatilong(
        locations.first.latitude,
        locations.first.longitude,
      );
    }
  } catch (e) {
    print("Geocoding error: $e");
  }
  return null;
}
