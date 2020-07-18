import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time;
  String flagURL;
  String urlEndpoint;
  bool status;
  bool DayTime;
  WorldTime({this.location, this.flagURL, this.urlEndpoint});

  void setDayTimeBool(String time) {
    DayTime = (int.parse(time.split(':')[0]) > 18 ||
            int.parse(time.split(':')[0]) < 5)
        ? false
        : true;
  }

  Future<void> getTime() async {
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

      time = DateFormat.Hm().format(now); //set the time property
      setDayTimeBool(time);
      time = now.toString();
      status = true;
    } catch (e) {
      print('caught error : $e');
      status = false;
    }
  }
}
