part of models;

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    AppUser? user,
    @Default(<AppUser>[]) List<AppUser> users,
  }) = AuthState$;

  factory AuthState.fromJson(Map<dynamic, dynamic> json) => _$AuthStateFromJson(Map<String, dynamic>.from(json));
}
