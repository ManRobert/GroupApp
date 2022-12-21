library actions;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:group_app/src/models/index.dart';

part 'index.freezed.dart';

part 'auth/login.dart';

part 'auth/logout.dart';

part 'auth/create_user.dart';

part 'auth/initialize_user.dart';

part 'location/get_location.dart';

part 'location/listen_for_location.dart';

typedef ActionResponse = void Function(dynamic action);
