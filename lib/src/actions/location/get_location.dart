part of actions;

@freezed
class GetLocation with _$GetLocation {
  const factory GetLocation.start() = GetLocationStart;

  const factory GetLocation.done() = GetLocationDone;

  const factory GetLocation.error(Object error, StackTrace stackTrace) = GetLocationError;
}
