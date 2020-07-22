import 'package:flutter/material.dart';
import 'package:WorldClock/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:WorldClock/utils/database.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoading = true;

  void setupWorldTime() async {
    setState(() {
      isLoading = true;
    });

    List<WorldTime> worldTimes = [];
    // loading from database
    // if database has query -> load into list
    // if database has no items -> create Local Time query -> insert into query -> load into list

    try {
      if (await DatabaseProvider().queryRowCount() == 0) {
        // creating localtime object
        WorldTime instance;
        instance = WorldTime(
            id: 1,
            //setting default time as local time
            location: 'Local time',
            flagURL: 'local.png',
            urlEndpoint: 'LOCALTIME');
        // inserting query into database
        DatabaseProvider().insertWorldTime(instance);
        await instance.getTime();
        worldTimes.add(instance);
      } else {
        worldTimes = await DatabaseProvider().readDatabase();
        worldTimes = worldTimes
            .map((worldtime) async {
              await worldtime.getTime();
              return worldtime;
            })
            .cast<WorldTime>()
            .toList();
      }
    } catch (e) {
      print('error in loading or initing database. => $e');
      setState(() {
        isLoading = false;
      });
    }
    // send data to home view
    if (worldTimes != null && worldTimes.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'WorldTimeObjects': worldTimes,
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(25),
            child: Center(
                child: LoaderRetry(
                    status: isLoading,
                    func: () {
                      setupWorldTime();
                    }))),
      ),
    );
  }
}

class LoaderRetry extends StatelessWidget {
  final bool status;
  final Function func;

  LoaderRetry({this.status, this.func});
  @override
  Widget build(BuildContext context) {
    if (status) {
      return SpinKitRotatingCircle(
        color: Colors.white,
        size: 50,
      );
    } else {
      return RaisedButton.icon(
          onPressed: func, icon: Icon(Icons.refresh), label: Text('Retry'));
    }
  }
}
