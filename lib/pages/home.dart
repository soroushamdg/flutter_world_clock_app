import 'dart:async';
import 'package:WorldClock/services/back_ground.dart';
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
  String backgroundURL = '';

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

  void getUpdateBackground() async {
    BackGrounder bg =
        BackGrounder(location: data['location'], light: data['daytime']);
    await bg.get_background();
    if (bg.image_url != null && bg.image_url.isNotEmpty) {
      setState(() {
        backgroundURL = bg.image_url;
      });
    } else {
      setState(() {
        backgroundURL = '';
      });
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
        getUpdateBackground();
      }
    } catch (e) {
      print('error => setting Time value => $e');
    }

    return Scaffold(
      backgroundColor: (data['daytime']) ? Colors.white : Colors.black87,
      body: Container(
        decoration: (this.backgroundURL.isNotEmpty)
            ? BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'http://' + this.backgroundURL.split('//')[1]),
                    fit: BoxFit.cover))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              color: (data['daytime']) ? Colors.white : Colors.white10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data['location'],
                        style: TextStyle(
                          fontSize: 28,
                          letterSpacing: 2,
                          color:
                              (data['daytime']) ? Colors.black87 : Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        DateFormat.Hm().format(Time),
                        style: TextStyle(
                          fontSize: 60,
                          color:
                              (data['daytime']) ? Colors.black87 : Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic RecData = await Navigator.pushNamed(context, '/location');
          if (RecData != null) {
            setState(() {
              data = {
                'location': RecData['location'],
                'flag': RecData['flag'],
                'time': RecData['time'],
                'daytime': RecData['daytime'],
              };

              Time = DateTime.parse(data['time']);
              getUpdateBackground();
            });
          }
          ;
        },
        child: Icon(
          Icons.map,
          color: (data['daytime']) ? Colors.white : Colors.blue[50],
        ),
        backgroundColor: (data['daytime']) ? Colors.blueAccent : Colors.white60,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
