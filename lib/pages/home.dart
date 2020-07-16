import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    print('data : $data');
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
              data['time'],
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
    // TODO: implement dispose
    super.dispose();
  }
}
