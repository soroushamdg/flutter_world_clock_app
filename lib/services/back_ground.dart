import 'dart:convert';

import 'package:http/http.dart';

String API_ACCESSKEY = '';

class BackGrounder {
  String location;
  bool light; // light image or dark image
  String image_url;

  BackGrounder({this.location, this.light});

  Future<void> get_background() async {
    print('running get background');
    try {
      Uri uri = Uri.https('api.unsplash.com', '/search/photos', {
        'query': this.location + " ${(light) ? 'day' : 'night'}",
        'orientation': 'portrait',
        'client_id': API_ACCESSKEY,
      });
      Response response = await get(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map jsonData = jsonDecode(response.body);
        this.image_url = jsonData['results'][0]['urls']['regular'];
        print(this.image_url);
      }
    } catch (e) {
      print('error in getting background => $e');
    }
  }
}
