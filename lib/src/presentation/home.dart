import 'package:flutter/widgets.dart';
import 'package:group_app/src/models/index.dart';

import 'package:group_app/src/presentation/containers/user_container.dart';
import 'package:group_app/src/presentation/home_page.dart';
import 'package:group_app/src/presentation/login_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser? user) {
        if (user == null) {
          return const LoginPage();
        } else {
          return const HomePage();
        }
      },
    );
  }
}
