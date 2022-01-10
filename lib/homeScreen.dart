import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nested_tab_nav/providers/navigationBarProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentSelectedTab = 0;

  late List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late AnimationController navigationContainerAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context
          .read<NavigationBarProvider>()
          .setAnimationController(navigationContainerAnimationController);
    });
  }

  @override
  void dispose() {
    navigationContainerAnimationController.dispose();
    super.dispose();
  }

  late List<Widget> _tabs = [
    Navigator(
      key: _navigatorKeys.first,
      onGenerateRoute: (routeSettings) {
        //
        return MaterialPageRoute(builder: (_) => HomeContainer());
      },
    ),

    Navigator(
      key: _navigatorKeys[1],
      onGenerateRoute: (routeSettings) {
        //
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_balance,
                          size: 40,
                        )),
                  ),
                  appBar: AppBar(
                    title: Text("Account Balance"),
                  ),
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
        return MaterialPageRoute(builder: (_) => SettingsContainer());
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
        body: Stack(children: [
          IndexedStack(
            index: _currentSelectedTab,
            children: _tabs,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                      parent: navigationContainerAnimationController,
                      curve: Curves.easeInOut)),
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
                        .animate(CurvedAnimation(
                            parent: navigationContainerAnimationController,
                            curve: Curves.easeInOut)),
                child: BottomNavigationBar(
                    currentIndex: _currentSelectedTab,
                    onTap: (index) {
                      if (_navigatorKeys[_currentSelectedTab]
                          .currentState!
                          .canPop()) {
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
                        icon: Icon(Icons.account_balance),
                      ),
                      BottomNavigationBarItem(
                        label: "",
                        icon: Icon(Icons.settings),
                      ),
                    ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class HomeContainer extends StatefulWidget {
  HomeContainer({Key? key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late WebViewController _webViewController;

  int _previousScrollY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(() {
            return VerticalDragGestureRecognizer()
              ..onDown = (dragDownDetails) async {
                //print(dragDownDetails.globalPosition);
                int currentScrollY = await _webViewController.getScrollY();

                if (currentScrollY > _previousScrollY) {
                  _previousScrollY = currentScrollY;
                  if (!context
                      .read<NavigationBarProvider>()
                      .animationController
                      .isAnimating) {
                    context
                        .read<NavigationBarProvider>()
                        .animationController
                        .forward();
                  }
                } else {
                  _previousScrollY = currentScrollY;

                  if (!context
                      .read<NavigationBarProvider>()
                      .animationController
                      .isAnimating) {
                    context
                        .read<NavigationBarProvider>()
                        .animationController
                        .reverse();
                  }
                }
              };
          })),
        onWebViewCreated: (webViewController) {
          _webViewController = webViewController;
        },
        initialUrl: "https://pub.dev/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class SettingsContainer extends StatefulWidget {
  SettingsContainer({Key? key}) : super(key: key);

  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  late WebViewController _webViewController;

  int _previousScrollY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        gestureRecognizers: Set()
          ..add(Factory<VerticalDragGestureRecognizer>(() {
            return VerticalDragGestureRecognizer()
              ..onDown = (dragDownDetails) async {
                // print(dragDownDetails.globalPosition);
                int currentScrollY = await _webViewController.getScrollY();

                if (currentScrollY > _previousScrollY) {
                  _previousScrollY = currentScrollY;
                  if (!context
                      .read<NavigationBarProvider>()
                      .animationController
                      .isAnimating) {
                    context
                        .read<NavigationBarProvider>()
                        .animationController
                        .forward();
                  }
                } else {
                  _previousScrollY = currentScrollY;

                  if (!context
                      .read<NavigationBarProvider>()
                      .animationController
                      .isAnimating) {
                    context
                        .read<NavigationBarProvider>()
                        .animationController
                        .reverse();
                  }
                }
              };
          })),
        onWebViewCreated: (webViewController) {
          _webViewController = webViewController;
        },
        initialUrl: "https://codecanyon.net/user/wrteam/portfolio",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
