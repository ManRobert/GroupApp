import 'package:group_app/src/actions/index.dart';
import 'package:group_app/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<LocationState> locationReducer = combineReducers(<Reducer<LocationState>>[
  TypedReducer<LocationState, OnLocationsEvent>(_onLocationEvent),
]);

LocationState _onLocationEvent(LocationState state, OnLocationsEvent action) {
  return state.copyWith(
    locations: action.locations,
  );
}
