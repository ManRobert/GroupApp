import 'package:group_app/src/actions/index.dart';
import 'package:group_app/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<LocationState> locationReducer = combineReducers(<Reducer<LocationState>>[
  TypedReducer<LocationState, GetLocationSuccessful>(_getLocationSuccessful),
]);

LocationState _getLocationSuccessful(LocationState state, GetLocationSuccessful action) {
  return state.copyWith(
    userLocation: action.location,
  );
}
