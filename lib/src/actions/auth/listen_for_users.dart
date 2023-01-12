part of actions;

@freezed
class ListenForUsers with _$ListenForUsers {
  const factory ListenForUsers.start() = ListenForUsersStart;

  const factory ListenForUsers.done() = ListenForUsersDone;

  const factory ListenForUsers.event(List<AppUser> users) = OnUsersEvent;

  const factory ListenForUsers.error(Object error, StackTrace stackTrace) = _ListenForUsersError;
}
