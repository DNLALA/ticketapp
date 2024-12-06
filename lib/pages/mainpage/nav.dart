import 'package:flutter/material.dart';
import 'package:ticketapp/pages/mainpage/events.dart'; // Assuming MyEvents is imported correctly
import 'package:ticketapp/pages/mainpage/home.dart';
import 'package:ticketapp/pages/mainpage/profile.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Center(child: Text('For You')),
    const MyEvents(),
    const Center(child: Text('Explore')),
    // Make sure this points to your MyEvents widget
    ProfilePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index.clamp(0, _widgetOptions.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: Container(
          height: screenHeight * 0.099,
          decoration: BoxDecoration(),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            selectedItemColor: const Color.fromARGB(255, 5, 42, 251),
            unselectedItemColor: Color.fromARGB(255, 122, 122, 122),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? Image.asset('assets/images/home-house_svgrepo.com.png')
                    : Image.asset('assets/images/home-house_svgrepo.com-.png'),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/🦆 icon _search_.png'),
                label: 'For You',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? Image.asset(
                        'assets/images/concert-tickets_svgrepo.com-.png')
                    : Image.asset(
                        'assets/images/concert-tickets_svgrepo.com.png'),
                label: 'My Events',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/Vector.png'),
                label: 'Sell',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 4
                    ? Image.asset('assets/images/active_circle.png')
                    : Image.asset('assets/images/circle.png'),
                label: 'My Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
