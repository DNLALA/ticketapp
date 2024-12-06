import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ticketapp/pages/ticket/allticket.dart';
import 'package:ticketapp/services/database_helper.dart';
import 'package:ticketapp/model/datamodel.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Map<String, dynamic>> _showsWithTicketCounts = [];
  bool isUpcomingSelected = true; // Track the active tab

  @override
  void initState() {
    super.initState();
    _loadShowsWithTicketCounts();
  }

  Future<void> _loadShowsWithTicketCounts() async {
    final showsWithTicketCounts =
        await DatabaseHelper.getShowsWithDistinctTicketsAndTicketCount();
    setState(() {
      _showsWithTicketCounts = showsWithTicketCounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E272E),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'My Events',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8), // Space between icon and text
            Container(
              width: 20, // Set the size for the circle
              height: 20, // Set the size for the circle
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 1, // Border width
                ),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/american_flag.png'), // American flag image
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Action when the "Help" text is pressed
            },
            child: const Text(
              'Help',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Navigation Bar
          Container(
            color: const Color.fromARGB(255, 4, 108, 226),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isUpcomingSelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: isUpcomingSelected
                              ? const BorderSide(color: Colors.white, width: 2)
                              : BorderSide.none,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Upcoming (${_showsWithTicketCounts.length})', // Dynamically update count
                        style: TextStyle(
                          color: isUpcomingSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 206, 206, 206),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isUpcomingSelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: !isUpcomingSelected
                              ? const BorderSide(color: Colors.white, width: 2)
                              : BorderSide.none,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Past (0)', // Static count for past events
                        style: TextStyle(
                          color: !isUpcomingSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Event List (Placeholder for Upcoming and Past Events)
          Expanded(
            child: isUpcomingSelected
                ? _buildUpcomingEvents()
                : _buildPastEvents(),
          ),
        ],
      ),
    );
  }

  // Upcoming Events List
  Widget _buildUpcomingEvents() {
    return ListView.builder(
      itemCount: _showsWithTicketCounts.length,
      itemBuilder: (context, index) {
        final show = Show.fromJson(_showsWithTicketCounts[index]);
        final ticketCount = _showsWithTicketCounts[index]['ticketCount'];
        final artistImage =
            _showsWithTicketCounts[index]['artistImage'] as Uint8List;
        final artistName = _showsWithTicketCounts[index]['artistName'];
        final showName = _showsWithTicketCounts[index]['name'];
        final claimedTickets = 0; // Static, adjust based on your data model

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              String showData =
                  '${show.weekday}, ${getMonthName(show.month)} ${show.day}, ${show.time} ${show.location}';
              String date = '2024-${show.month}-${show.day} ${show.time}';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketListForShow(
                    showId: show.id!,
                    showData: showData,
                    date: date,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vertical "New" Header at the top of the card
                Container(
                  width: 412, // Same width as the card
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  color: const Color.fromARGB(
                      255, 129, 15, 150), // Purple background
                  child: const Center(
                    child: Text(
                      'NEW DATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Event card content below the header
                Container(
                  height: 200,
                  width: 412,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 111, 110, 110),
                    image: DecorationImage(
                      image: MemoryImage(artistImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: const Color.fromARGB(184, 0, 0, 0),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align content to the bottom
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Artist and show name
                        Text(
                          '$artistName - $showName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Date and location
                        Text(
                          '${show.weekday}, ${getMonthName(show.month)} ${show.day}, ${show.time} . ${show.location}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Tickets and claimed status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Ticket count
                            Row(
                              children: [
                                Transform.rotate(
                                  angle:
                                      2, // Horizontal orientation (no rotation needed by default)
                                  child: const Icon(
                                    Icons.confirmation_number,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        4), // Adjust spacing between the icon and text
                                Text(
                                  '$ticketCount tickets',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 20),
                            // Claimed tickets (static as 0 for now)
                            Row(
                              children: [
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size:
                                      24, // Increased size to make it appear thicker
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '0 claimed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Past Events List (Static Placeholder)
  Widget _buildPastEvents() {
    return const Center(
      child: Text(
        'No Past Events',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  String getMonthName(String month) {
    switch (month) {
      case '01':
        return 'Jan';
      case '02':
        return 'Feb';
      case '03':
        return 'Mar';
      case '04':
        return 'Apr';
      case '05':
        return 'May';
      case '06':
        return 'Jun';
      case '07':
        return 'Jul';
      case '08':
        return 'Aug';
      case '09':
        return 'Sep';
      case '10':
        return 'Oct';
      case '11':
        return 'Nov';
      case '12':
        return 'Dec';
      default:
        return '';
    }
  }
}
