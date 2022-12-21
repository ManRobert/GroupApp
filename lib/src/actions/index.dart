library actions;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:group_app/src/models/index.dart';

part 'index.freezed.dart';

part 'login.dart';

part 'logout.dart';

part 'create_user.dart';

typedef ActionResponse = void Function(dynamic action);
