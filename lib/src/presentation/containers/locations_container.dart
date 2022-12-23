import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_app/src/models/index.dart';
import 'package:redux/redux.dart';

class LocationsContainer extends StatelessWidget {
  const LocationsContainer({super.key, required this.builder});

  final ViewModelBuilder<List<UserLocation>> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<UserLocation>>(
      builder: builder,
      converter: (Store<AppState> store) {
        return store.state.location.locations;
      },
    );
  }
}
