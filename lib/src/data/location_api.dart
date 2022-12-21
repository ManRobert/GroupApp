import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_app/src/models/index.dart';
import 'package:location/location.dart';

class LocationApi {
  const LocationApi({required this.location, required this.firestore});

  final Location location;
  final FirebaseFirestore firestore;

  Future<UserLocation?> getLocation(String uid) async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.denied || permissionStatus == PermissionStatus.deniedForever) {
      permissionStatus = await location.requestPermission();

      if (permissionStatus == PermissionStatus.denied || permissionStatus == PermissionStatus.deniedForever) {
        return null;
      }
    }
    final LocationData result = await location.getLocation();

    final UserLocation userLocation = UserLocation(lat: result.latitude ?? 0.0, lng: result.longitude ?? 0.0, uid: uid);

    await firestore.collection('locations').doc(uid).set(userLocation.toJson());
    return userLocation;
  }

  Stream<List<UserLocation>> listenLocations() {
    return firestore.collection('locations').snapshots().map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => UserLocation.fromJson(doc.data()))
          .toList();
    });
  }
}
