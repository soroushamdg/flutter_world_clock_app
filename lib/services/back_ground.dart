import 'dart:convert';

import 'package:http/http.dart';

class BackGrounder {
  String location;
  bool light; // light image or dark image
  String image_url;

  BackGrounder({this.location, this.light});

  Future<void> get_background() async {
    try {
      Uri uri = Uri.https('www.api.unsplash.com', '/search/photos', {
        'query': this.location + " ${(light) ? 'light' : 'dark'}",
        'orientation': 'portrait',
      });

      Response response = await get(uri);
      if (response.statusCode == 200) {
        Map jsonData = jsonDecode(response.body);
        this.image_url = jsonData['results'][0]['urls']['regular'];
      }
    } catch (e) {
      print('error in getting background => $e');
    }
  }
}
