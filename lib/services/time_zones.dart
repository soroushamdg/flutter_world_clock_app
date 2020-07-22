import 'dart:convert';

import 'package:http/http.dart';
import 'world_time.dart';

List<WorldTime> locations;

Future<List<WorldTime>> DefineLocations() async {
  try {
    Response response = await get('http://worldtimeapi.org/api/timezone/');

    List<dynamic> data = jsonDecode(response.body);
    locations = data.map((timezone) {
      if (timezone.toString().contains('/')) {
        return WorldTime(
            id: 0,
            location: timezone.split('/')[1],
            flagURL: timezone.split('/')[1].toString().toLowerCase() + '.png',
            urlEndpoint: timezone);
      }
    }).toList();
    return locations;
  } catch (Exception) {
    print('error happend : $Exception');
  }
}
