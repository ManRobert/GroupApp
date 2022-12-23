part of actions;

@freezed
class ListenForLocations with _$ListenForLocations {
  const factory ListenForLocations.start() = ListenForLocationsStart;

  const factory ListenForLocations.done() = ListenForLocationsDone;

  const factory ListenForLocations.event(List<UserLocation> locations) = OnLocationsEvent;

  const factory ListenForLocations.error(Object error, StackTrace stackTrace) = _ListenForLocationsError;
}
