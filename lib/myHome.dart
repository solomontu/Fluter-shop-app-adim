import 'package:flutter/material.dart';

import 'dashBoard/DashHome.dart';
import 'homePage.dart';
// import 'testing.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          title: Text('Dashboard'),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Dboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.shopping_bag_outlined),
                    selectedIcon: Icon(Icons.shopping_bag),
                    label: Text('More'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(child: pageSellector()),
            ),
          ],
        ));
  }

  Widget pageSellector() {
    switch (_selectedIndex) {
      case 0:
        return Dashboard();
        break;
      case 1:
        return MyHomePage();
        break;
      default:
        return
            // Testing();
            Dashboard();
    }
  }
}
