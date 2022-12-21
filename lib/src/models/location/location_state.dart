part of models;

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    UserLocation? userLocation,
    @Default(<UserLocation>[]) List<UserLocation> locations,
  }) = LocationState$;

  factory LocationState.fromJson(Map<dynamic, dynamic> json) =>
      _$LocationStateFromJson(Map<String, dynamic>.from(json));
}
