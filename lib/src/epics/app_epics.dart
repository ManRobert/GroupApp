import 'package:group_app/src/data/auth_api.dart';
import 'package:group_app/src/data/location_api.dart';
import 'package:group_app/src/epics/auth_epics.dart';
import 'package:group_app/src/epics/location_epics.dart';
import 'package:group_app/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';

class AppEpics {
  const AppEpics({required this.authApi, required this.locationApi});

  final AuthApi authApi;
  final LocationApi locationApi;

  Epic<AppState> get epic {
    return combineEpics(<Epic<AppState>>[
      AuthEpics(authApi).epic,
      LocationEpics(locationApi).epic,
    ]);
  }
}
