import 'package:flutter/material.dart';

class TrackService extends StatefulWidget {
  @override
  _TrackServiceState createState() => _TrackServiceState();
}

class _TrackServiceState extends State<TrackService> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Track",style: Theme.of(context).textTheme.headline6,),
            trailing: Text(
              "exprezy",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Nothing to track",style: Theme.of(context).textTheme.headline4,),
          )
        ],
      ),
    );
  }
}
