import 'dart:async';
import 'package:WorldClock/services/back_ground.dart';
import 'package:WorldClock/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  DateTime Time;
  Timer timer;
  String backgroundURL = '';
  List<WorldTime> Clocks;

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
        BackGrounder(location: Clocks[0].location, light: Clocks[0].DayTime);
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

  BoxDecoration returnBackgroundImage() {
    if (this.backgroundURL.isNotEmpty) {
      try {
        try {
          var image =
              NetworkImage('http://' + this.backgroundURL.split('//')[1]);
        } catch (e) {
          print('error in downloading image => $e');
          return null;
        }
        return BoxDecoration(
            image: DecorationImage(
                image:
                    NetworkImage('http://' + this.backgroundURL.split('//')[1]),
                fit: BoxFit.cover));
      } catch (e) {
        print('error in returning background decoration image object');
        return null;
      }
    } else {
      return null;
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
    Clocks = data['WorldTimeObjects'];
    try {
      if (Time == null) {
        Time = DateTime.parse(Clocks[0].time);
        getUpdateBackground();
      }
    } catch (e) {
      print('error => setting Time value => $e');
    }

    return Scaffold(
      backgroundColor: (Clocks[0].DayTime) ? Colors.white : Colors.black87,
      body: Container(
        decoration: returnBackgroundImage(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: GestureDetector(
            child: (Clocks[0].clockAppearance == ClockAppearanceMode.digital)
                ? DigitalClockCard(worldtime: Clocks[0], Time: Time)
                : AnalogClockCard(worldtime: Clocks[0], Time: Time),
            onTap: () {
              setState(() {
                Clocks[0].toggleClockAppearance();
              });
            },
          )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO : ADD RECIEVED TIME ZONE OBJECT TO LIST OF TIMEZONES
          dynamic RecData = await Navigator.pushNamed(context, '/location');
          if (RecData != null) {
            setState(() {
              data = RecData;
              Clocks = data['WorldTimeObjects'];
              Time = DateTime.parse(Clocks[0].time);
              getUpdateBackground();
            });
          }
          ;
        },
        child: Icon(
          Icons.map,
          color: (Clocks[0].DayTime) ? Colors.white : Colors.blue[50],
        ),
        backgroundColor:
            (Clocks[0].DayTime) ? Colors.blueAccent : Colors.white60,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    // TODO: SAVE LIST OF TIMEZONES
  }
}

class AnalogClockCard extends StatefulWidget {
  const AnalogClockCard({
    Key key,
    @required this.worldtime,
    @required this.Time,
  }) : super(key: key);

  final WorldTime worldtime;
  final DateTime Time;

  @override
  _AnalogClockCardState createState() => _AnalogClockCardState();
}

class _AnalogClockCardState extends State<AnalogClockCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(side: BorderSide(color: Colors.white70, width: 0.5)),
      child: FlutterAnalogClock(
        dateTime: widget.Time,
        dialPlateColor:
            (widget.worldtime.DayTime) ? Colors.white : Colors.black87,
        hourHandColor:
            (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        minuteHandColor:
            (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        secondHandColor:
            (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        numberColor:
            (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        borderColor:
            (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        tickColor: (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        centerPointColor:
            (widget.worldtime.DayTime) ? Colors.black87 : Colors.white70,
        showBorder: true,
        showTicks: true,
        showMinuteHand: true,
        showSecondHand: true,
        showNumber: true,
        borderWidth: 6.0,
        hourNumberScale: .10,
        width: 200.0,
        height: 200.0,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset('assets/img_world_map.png'),
                ),
                Text(
                  widget.worldtime.location,
                  style: TextStyle(
                    color: (widget.worldtime.DayTime)
                        ? Colors.black45
                        : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DigitalClockCard extends StatefulWidget {
  const DigitalClockCard({
    Key key,
    @required this.worldtime,
    @required this.Time,
  }) : super(key: key);

  final WorldTime worldtime;
  final DateTime Time;

  @override
  _DigitalClockCardState createState() => _DigitalClockCardState();
}

class _DigitalClockCardState extends State<DigitalClockCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 0.5),
        borderRadius: BorderRadius.circular(80),
      ),
      color: (widget.worldtime.DayTime) ? Colors.white : Colors.white10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
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
                widget.worldtime.location,
                style: TextStyle(
                  fontSize: 28,
                  letterSpacing: 2,
                  color: (widget.worldtime.DayTime)
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                DateFormat.Hm().format(widget.Time),
                style: TextStyle(
                  fontSize: 60,
                  color: (widget.worldtime.DayTime)
                      ? Colors.black87
                      : Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
