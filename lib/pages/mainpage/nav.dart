import 'package:flutter/material.dart';
import 'package:ticketapp/pages/mainpage/events.dart'; // Assuming MyEvents is imported correctly
import 'package:ticketapp/pages/mainpage/home.dart';
import 'package:ticketapp/pages/mainpage/profile.dart';
import 'package:flutter/cupertino.dart';

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
    ProfilePage(),
  ];

  void _onItemTap(int index) {
    if (index == 4 && _selectedIndex == 4) {
      // If the "My Account" tab is tapped while it's already selected, don't navigate
      return;
    }
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
            selectedItemColor: const Color.fromARGB(255, 4, 78, 250),
            unselectedItemColor: Color.fromARGB(255, 122, 122, 122),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 6.3, // Move the circle slightly upwards
                      left:
                          7.0, // Move the circle slightly to the left (or adjust based on your preference)
                      child: Container(
                        width: 12.0, // Adjust the size of the circle
                        height: 12.0, // Adjust the size of the circle
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? const Color.fromARGB(255, 4, 78, 250)
                              : Colors
                                  .grey, // Circle color based on active state
                          shape: BoxShape.circle, // Make the container a circle
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.search, // Cupertino icon for "search"
                      color: _selectedIndex == 0
                          ? const Color.fromARGB(255, 16, 85, 247)
                          : Colors.grey, // Icon color
                      size: 30.0, // Icon size
                    ),
                  ],
                ),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left:
                          5.0, // Adjust this value to move the back icon to the right
                      top:
                          -5.0, // Adjust this value to move the back icon slightly upwards
                      child: Icon(
                        Icons.favorite, // Gray heart icon at the back
                        color: const Color.fromARGB(
                            255, 201, 201, 201), // Gray color for the back icon
                        size: 30.0, // Adjust size as needed
                      ),
                    ),
                    Icon(
                      Icons.favorite, // Filled heart icon at the front
                      color: _selectedIndex == 1
                          ? const Color.fromARGB(255, 4, 78, 250)
                          : Colors.grey, // Front icon color, blue when selected
                      size: 30.0, // Adjust size to match
                    ),
                  ],
                ),
                label: 'For You',
              ),
              BottomNavigationBarItem(
                icon: Transform.rotate(
                  angle: 11.10111 / 2, // Keep the rotation angle stable
                  child: Icon(
                    CupertinoIcons.tickets_fill, // Cupertino icon for "tickets"
                    color: _selectedIndex == 2
                        ? const Color.fromARGB(255, 4, 78, 250)
                        : Colors
                            .grey, // Active color for selected, gray for others
                    size: 30.0, // Icon size
                  ),
                ),
                label: 'My Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle, // Replace with your desired icon
                  color: _selectedIndex == 3
                      ? const Color.fromARGB(255, 4, 78, 250)
                      : Colors.grey, // Icon color
                  size: 35.0, // Icon size
                ),
                label: 'My Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
