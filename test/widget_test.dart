// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_app/firebase_options.dart';

import 'package:group_app/main.dart';
import 'package:group_app/src/data/auth_api.dart';
import 'package:group_app/src/data/location_api.dart';
import 'package:group_app/src/epics/app_epics.dart';
import 'package:group_app/src/models/index.dart';
import 'package:group_app/src/reducer/reducer.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    final AuthApi authApi = AuthApi(auth: FirebaseAuth.instance);
    final LocationApi locationApi = LocationApi(location: Location(), firestore: FirebaseFirestore.instance);
    final AppEpics epics = AppEpics(authApi: authApi, locationApi: locationApi);
    final Store<AppState> store = Store<AppState>(
      reducer,
      initialState: const AppState(),
      middleware: <Middleware<AppState>>[
        EpicMiddleware<AppState>(epics.epic),
      ],
    );
    await tester.pumpWidget(GroupApp(store: store));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
