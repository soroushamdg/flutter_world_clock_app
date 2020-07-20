import 'package:flutter/material.dart';
import 'package:WorldClock/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool status = true;

  void setupWorldTime() async {
    setState(() {
      status = true;
    });
    WorldTime instance;
    try {
      // TODO : LOAD PREVIOUS LIST OF OBJECTS
      final prefs = await SharedPreferences
          .getInstance(); // loading from shared prefences
      final location = prefs.getString('last_location') ?? null;
      final flagURL = prefs.getString('last_flagurl') ?? null;
      final urlEndpoint = prefs.getString('last_urlEndpoint') ?? null;
      if (location.isNotEmpty && flagURL.isNotEmpty && urlEndpoint.isNotEmpty) {
        instance = WorldTime(
            //setting last world time.
            location: location,
            flagURL: flagURL,
            urlEndpoint: urlEndpoint);
        await instance.getTime();
      } else {
        instance = WorldTime(
            //setting default time as local time
            location: 'Local time',
            flagURL: 'local.png',
            urlEndpoint: 'LOCALTIME');
        instance.status = true;
        instance
            .setDayTimeBool(DateFormat.Hm().format(DateTime.now().toLocal()));
        instance.time = DateTime.now().toLocal().toString();
      }
    } catch (e) {
      print('error => loading last worldtime => $e');
      instance = WorldTime(
          //setting default time as local time
          location: 'Local time',
          flagURL: 'local.png',
          urlEndpoint: 'LOCALTIME');
      instance.status = true;
      instance.setDayTimeBool(DateFormat.Hm().format(DateTime.now().toLocal()));
      instance.time = DateTime.now().toLocal().toString();
    }
    if (instance.status == true) {
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'WorldTimeObjects': [instance],
      });
    } else {
      setState(() {
        status = false;
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
                    status: status,
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
