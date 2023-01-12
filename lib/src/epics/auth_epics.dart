import 'package:group_app/src/actions/index.dart';
import 'package:group_app/src/data/auth_api.dart';
import 'package:group_app/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/transformers.dart';

class AuthEpics {
  const AuthEpics(this._api);

  final AuthApi _api;

  Epic<AppState> get epic {
    return combineEpics(<Epic<AppState>>[
      TypedEpic<AppState, LoginStart>(_loginStart),
      TypedEpic<AppState, LogoutStart>(_logoutStart),
      TypedEpic<AppState, CreateUserStart>(_createUserStart),
      TypedEpic<AppState, InitializeUserStart>(_initializeUserStart),
      listenForUsersStart,
    ]);
  }

  Stream<dynamic> _loginStart(Stream<LoginStart> actions, EpicStore<AppState> store) {
    return actions.flatMap(
      (LoginStart action) => Stream<void>.value(null)
          .asyncMap((_) => _api.login(email: action.email, password: action.password))
          .map((AppUser user) => Login.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => Login.error(error, stackTrace))
          .doOnData(action.response),
    );
  }

  Stream<dynamic> _logoutStart(Stream<LogoutStart> actions, EpicStore<AppState> store) {
    return actions.flatMap(
      (LogoutStart action) => Stream<void>.value(null)
          .asyncMap((_) => _api.logout())
          .map((_) => const Logout.successful())
          .onErrorReturnWith((Object error, StackTrace stackTrace) => Logout.error(error, stackTrace)),
    );
  }

  Stream<dynamic> _createUserStart(Stream<CreateUserStart> actions, EpicStore<AppState> store) {
    return actions.flatMap(
      (CreateUserStart action) => Stream<void>.value(null)
          .asyncMap((_) => _api.createUser(email: action.email, password: action.password))
          .map((AppUser user) => CreateUser.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => CreateUser.error(error, stackTrace))
          .doOnData(action.response),
    );
  }

  Stream<void> _initializeUserStart(Stream<InitializeUserStart> actions, EpicStore<AppState> store) {
    return actions.flatMap(
      (InitializeUserStart action) => Stream<void>.value(null)
          .asyncMap((_) => _api.getUser())
          .map((AppUser? user) => InitializeUser.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => InitializeUser.error(error, stackTrace)),
    );
  }

  Stream<dynamic> listenForUsersStart(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ListenForLocationsStart>().flatMap(
          (ListenForLocationsStart action) => Stream<void>.value(null)
              .flatMap((_) => _api.getUsers())
              .map((List<AppUser> users) => ListenForUsers.event(users))
              .takeUntil(actions.whereType<ListenForLocationsDone>())
              .onErrorReturnWith((Object error, StackTrace stackTrace) => ListenForUsers.error(error, stackTrace)),
        );
  }
}
