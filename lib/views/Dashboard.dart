import 'package:exprezy/services/AuthService.dart';
import 'package:exprezy/services/SharedData.dart';
import 'package:exprezy/views/AppTheme.dart';
import 'package:exprezy/views/Home.dart';
import 'package:exprezy/views/MyBikes.dart';
import 'package:exprezy/views/MyProfile.dart';
import 'package:exprezy/views/TrackService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    MyBike(),
    TrackService(),
    MyProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.motorcycle),
                title: Text('My Bikes'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                title: Text('Track'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text('Profile'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueAccent,
            onTap: _onItemTapped,
          ),
        );
  }
}
