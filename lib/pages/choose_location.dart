import 'package:WorldClock/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:WorldClock/services/time_zones.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldTime> timezones;

  bool loading = true;

  Future<void> setTimezones() async {
    setState(() {
      loading = true;
    });
    timezones = await DefineLocations();
    if (timezones == null) {
      setState(() {
        loading = true;
      });
    } else {
      setState(() {
        timezones
            .removeWhere((value) => value == null); //remove nulls from list
        timezones.sort((a, b) => a.location.toString().compareTo(
            b.location.toString())); // sort list by location alphabeticaly
        loading = false;
      });
    }
  }

// TODO : RETURN TIME ZONE OBJECT TO HOME VIEW
  void updateTime(index) async {
    setState(() {
      loading = true;
    });
    WorldTime time = locations[index];
    await time.getTime();
    try {
      final prefs = await SharedPreferences
          .getInstance(); // loading from shared prefences
      prefs.setString('last_location', time.location);
      prefs.setString('last_flagurl', time.flagURL);
      prefs.setString('last_urlEndpoint', time.urlEndpoint);
    } catch (e) {
      print('error => saving new worldtime to shared prefences. => $e');
    }
    Navigator.pop(context, {
      'WorldTimeObjects': [time],
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimezones();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'),
        backgroundColor: Colors.amber[700],
      ),
      body: (loading)
          ? LoadingLocationsScene()
          : ChooseLocationScene(
              updateTime: updateTime,
            ),
    );
  }
}

class LoadingLocationsScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitChasingDots(
      color: Colors.amber[600],
    ));
  }
}

class ChooseLocationScene extends StatelessWidget {
  final Function updateTime;
  ChooseLocationScene({this.updateTime});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          child: Card(
            child: ListTile(
              onTap: () {
                updateTime(index);
              },
              title: Text(locations[index].location),
            ),
          ),
        );
      },
    );
  }
}
