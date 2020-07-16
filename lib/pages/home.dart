import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  DateTime Time;
  Timer timer;

  void updateTime() {
    setState(() {
      Time = Time.add(Duration(seconds: 1));
    });
  }

  void initUpdateTime() async {
    try {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateTime());
    } catch (e) {
      print('error => $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      initUpdateTime();
    } catch (Exception) {
      print('error => $Exception');
    }
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    try {
      if (Time == null) {
        Time = DateTime.parse(data['time']);
      }
    } catch (e) {
      print('error => setting Time value => $e');
    }
    return Scaffold(
      backgroundColor: (data['daytime']) ? Colors.black87 : Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 120, 0, 120),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  data['location'],
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 2,
                    color: (data['daytime']) ? Colors.white : Colors.black87,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              DateFormat.Hm().format(Time),
              style: TextStyle(
                fontSize: 60,
                color: (data['daytime']) ? Colors.white : Colors.black87,
              ),
            )
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic RecData = await Navigator.pushNamed(context, '/location');
          print(RecData);
          if (RecData != null) {
            setState(() {
              data = {
                'location': RecData['location'],
                'flag': RecData['flag'],
                'time': RecData['time'],
                'daytime': RecData['daytime'],
              };
              Time = DateTime.parse(data['time']);
            });
          }
          ;
        },
        child: Icon(
          Icons.map,
          color: (data['daytime']) ? Colors.blue[800] : Colors.white,
        ),
        backgroundColor: (data['daytime']) ? Colors.white54 : Colors.blueAccent,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
