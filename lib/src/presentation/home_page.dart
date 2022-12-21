import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_app/src/actions/index.dart';
import 'package:group_app/src/models/index.dart';
import 'package:group_app/src/presentation/containers/user_container.dart';
import 'package:group_app/src/presentation/containers/user_location_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false).dispatch(const GetLocation());
  }

  @override
  Widget build(BuildContext context) {
    return UserLocationContainer(
      builder: (BuildContext context, UserLocation? location) {
        return UserContainer(
          builder: (BuildContext context, AppUser? user) {
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text("${user!.displayName.toUpperCase()}'s home page")),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(const Logout());
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              body: Center(
                child: location == null ? const CircularProgressIndicator() : Text('$location'),
              ),
            );
          },
        );
      },
    );
  }
}
