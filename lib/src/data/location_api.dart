import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_app/src/models/index.dart';
import 'package:location/location.dart';

class LocationApi {
  const LocationApi({required this.location, required this.firestore});

  final Location location;
  final FirebaseFirestore firestore;

  Stream<void> getLocation(String uid) async* {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
      permission = await location.requestPermission();

      if (permission == PermissionStatus.denied || permission == PermissionStatus.deniedForever) {
        yield* const Stream<void>.empty();
        return;
      }
    }

    yield* location //
        .onLocationChanged
        .map((LocationData result) {
      return UserLocation(
        uid: uid,
        lat: result.latitude ?? 0.0,
        lng: result.longitude ?? 0.0,
      );
    }).asyncMap((UserLocation userLocation) {
      return firestore //
          .collection('locations')
          .doc(uid)
          .set(userLocation.toJson());
    });
  }

  Stream<List<UserLocation>> listenForLocations() {
    return firestore.collection('locations').snapshots().map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => UserLocation.fromJson(doc.data()))
          .toList();
    });
  }
}
