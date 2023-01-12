import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_app/secrets/secrets.dart';
import 'package:group_app/src/actions/index.dart';
import 'package:group_app/src/models/index.dart';
import 'package:group_app/src/presentation/containers/locations_container.dart';
import 'package:group_app/src/presentation/containers/user_container.dart';
import 'package:group_app/src/presentation/containers/users_container.dart';
import 'package:latlong2/latlong.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _controller = MapController();

  late Store<AppState> _store;

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _store
      ..dispatch(const GetLocation.start())
      ..dispatch(const ListenForLocations.start())
      ..dispatch(const ListenForUsers.start());
  }

  @override
  void dispose() {
    _store.dispatch(const ListenForLocations.done());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocationsContainer(
      builder: (BuildContext context, List<UserLocation> locations) {
        return UserContainer(
          builder: (BuildContext context, AppUser? user) {
            final UserLocation? currentUserLocation =
                locations.firstWhereOrNull((UserLocation location) => location.uid == user?.uid);

            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text("${user!.displayName.toUpperCase()}'s home page")),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(const Logout());
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              body: currentUserLocation == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FlutterMap(
                      mapController: _controller,
                      options: MapOptions(
                        center: LatLng(currentUserLocation.lat, currentUserLocation.lng),
                        zoom: 18,
                      ),
                      children: <Widget>[
                        TileLayer(
                          urlTemplate: urlTemplate,
                          additionalOptions: <String, String>{'access_token': token},
                        ),
                        UsersContainer(
                          builder: (BuildContext context, List<AppUser> users) {
                            return MarkerLayer(
                              markers: <Marker>[
                                for (final UserLocation location in locations)
                                  Marker(
                                    point: LatLng(location.lat, location.lng),
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          final AppUser? selectedUser =
                                              users.firstWhereOrNull((AppUser user) => user.uid == location.uid);
                                          if (selectedUser == null) {
                                            return;
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(content: Text(selectedUser.displayName)));
                                        },
                                        child: Icon(
                                          Icons.location_pin,
                                          color: location.uid != user.uid ? Colors.black : Colors.blueAccent,
                                        ),
                                      );
                                    },
                                  )
                              ],
                            );
                          },
                        )
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
