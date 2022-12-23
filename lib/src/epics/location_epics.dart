import 'package:group_app/src/actions/index.dart';
import 'package:group_app/src/data/location_api.dart';
import 'package:group_app/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/transformers.dart';

class LocationEpics {
  const LocationEpics(this._api);

  final LocationApi _api;

  Epic<AppState> get epic {
    return combineEpics(<Epic<AppState>>[
      _getLocationStart,
      _listenForLocationsStart,
    ]);
  }

  Stream<dynamic> _getLocationStart(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<GetLocationStart>().flatMap((GetLocationStart action) {
      return Stream<void>.value(null) //
          .flatMap<dynamic>((_) => _api.getLocation(store.state.auth.user!.uid))
          .takeUntil(actions.whereType<GetLocationDone>())
          .ignoreElements()
          .cast<void>()
          .onErrorReturnWith((Object error, StackTrace stackTrace) => GetLocation.error(error, stackTrace));
    });
  }

  Stream<dynamic> _listenForLocationsStart(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ListenForLocationsStart>().flatMap(
          (ListenForLocationsStart action) => Stream<void>.value(null)
              .flatMap((_) => _api.listenForLocations())
              .map((List<UserLocation> locations) => ListenForLocations.event(locations))
              .takeUntil(actions.whereType<ListenForLocationsDone>())
              .onErrorReturnWith((Object error, StackTrace stackTrace) => ListenForLocations.error(error, stackTrace)),
        );
  }
}
