import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSelectedTab = 0;

  late List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late List<Widget> _tabs = [
    Navigator(
      key: _navigatorKeys.first,
      onGenerateRoute: (routeSettings) {
        //
        return MaterialPageRoute(
            builder: (_) => Column(
                  children: [
                    AppBar(
                      title: Text("Home"),
                    ),
                    Center(
                      child: Icon(
                        Icons.home,
                        size: 40,
                      ),
                    )
                  ],
                ));
      },
    ),
    //
    Navigator(
      key: _navigatorKeys.last,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "/aboutUs") {
          return CupertinoPageRoute(
              builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: Text("About us"),
                    ),
                  ));
        }

        //
        return MaterialPageRoute(
            builder: (_) => Column(
                  children: [
                    AppBar(
                      title: Text("Settings"),
                    ),
                    Center(
                      child: IconButton(
                          onPressed: () {
                            print("Navigate to new page");
                            _navigatorKeys[_currentSelectedTab]
                                .currentState!
                                .pushNamed("/aboutUs");
                          },
                          icon: Icon(
                            Icons.settings,
                            size: 40,
                          )),
                    )
                  ],
                ));
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //
        if (_currentSelectedTab != 0) {
          if (_navigatorKeys[_currentSelectedTab].currentState!.canPop()) {
            //
            _navigatorKeys[_currentSelectedTab]
                .currentState!
                .popUntil((route) => route.isFirst);
          }

          //
          setState(() {
            _currentSelectedTab = 0;
          });
          return Future.value(false);
        }

        //

        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentSelectedTab,
            onTap: (index) {
              if (_navigatorKeys[_currentSelectedTab].currentState!.canPop()) {
                //
                _navigatorKeys[_currentSelectedTab]
                    .currentState!
                    .popUntil((route) => route.isFirst);
              }
              setState(() {
                _currentSelectedTab = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: Icon(Icons.settings),
              )
            ]),
        body: IndexedStack(
          index: _currentSelectedTab,
          children: _tabs,
        ),
      ),
    );
  }
}
