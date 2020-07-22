import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'back_ground.dart';

enum ClockAppearanceMode { digital, analog } // 2 state for clock appereance.

class WorldTime {
  int id;
  final String location;
  DateTime time;
  String flagURL;
  final String urlEndpoint;
  bool status;
  bool DayTime;
  String backgroundURL = '';
  WorldTime({this.id, this.location, this.flagURL, this.urlEndpoint});

  var clockAppearance = ClockAppearanceMode.digital;

  void toggleClockAppearance() {
    if (clockAppearance == ClockAppearanceMode.analog) {
      clockAppearance = ClockAppearanceMode.digital;
    } else {
      clockAppearance = ClockAppearanceMode.analog;
    }
  }

  void setDayTimeBool(String time) {
    DayTime = (int.parse(time.split(':')[0]) > 18 ||
            int.parse(time.split(':')[0]) < 5)
        ? false
        : true;
  }

  Future<void> getTime() async {
    if (urlEndpoint == 'LOCALTIME') {
      status = true;
      setDayTimeBool(DateFormat.Hm().format(DateTime.now().toLocal()));
      time = DateTime.now().toLocal();
      return;
    }
    try {
      Response response =
          await get('http://worldtimeapi.org/api/timezone/$urlEndpoint');

      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      Map offset = {
        'sign': data['utc_offset'].substring(0, 1),
        'hour': data['utc_offset'].substring(1, 3),
        'minutes': data['utc_offset'].substring(4, 6),
      };

      DateTime now = DateTime.parse(datetime);

      now = (offset['sign'] == '+')
          ? now.add(Duration(
              hours: int.parse(offset['hour']),
              minutes: int.parse(offset['minutes'])))
          : now.subtract(Duration(
              hours: int.parse(offset['hour']),
              minutes: int.parse(offset['minutes'])));

      setDayTimeBool(DateFormat.Hm().format(now));
      await getBackgroundURL();
      time = now;
      status = true;
    } catch (e) {
      print('caught error : $e');
      status = false;
    }
  }

  /// integrating database, map function
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'urlepoint': urlEndpoint,
      'clockAppereance':
          (clockAppearance == ClockAppearanceMode.digital) ? 0 : 1,
    };
  }

  Future<void> getBackgroundURL() async {
    BackGrounder bg =
        BackGrounder(location: this.location, light: this.DayTime);
    await bg.get_background();
    this.backgroundURL = bg.image_url;
    print(this.backgroundURL);
  }
}
