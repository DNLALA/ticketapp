import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ticketapp/services/database_helper.dart';

class TransfarSymbol extends StatefulWidget {
  final int userId;
  final int showId;
  final String showData;

  const TransfarSymbol({
    Key? key,
    required this.userId,
    required this.showId,
    required this.showData,
  }) : super(key: key);

  @override
  State<TransfarSymbol> createState() => _TransfarSymbolState();
}

class _TransfarSymbolState extends State<TransfarSymbol> {
  late Future<List<Map<String, dynamic>>> _userTicketsFuture;
  late Future<List<Map<String, dynamic>>> _showFuture;

  @override
  void initState() {
    super.initState();
    _loadUserTickets();
  }

  Future<void> _loadUserTickets() async {
    _userTicketsFuture = DatabaseHelper.getUserTickets(widget.userId);
    _showFuture = DatabaseHelper.getShowById(widget.showId);
    setState(() {}); // Update the state to refresh the UI with new data
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0163D5),
        title: Row(
          children: [
            const Icon(
              Icons.close,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ticketmaster Event',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  widget.showData,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _showFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Show data not available');
                } else {
                  final show = snapshot.data!.first;
                  return Column(
                    children: [
                      Container(
                        height: 167,
                        width: 393,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 111, 110, 110),
                          image: show['artistImage'] != null
                              ? DecorationImage(
                                  image: MemoryImage(show['artistImage']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Container(
                          height: 201,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            // color: Color.fromARGB(255, 111, 110, 110),
                            image: DecorationImage(
                              image: MemoryImage(show['artistImage']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 77,
                                            width: 107,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 111, 110, 110),
                                              image: DecorationImage(
                                                image: MemoryImage(
                                                    show['artistImage']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // child: Image.memory(artistImage)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            'Order #${show['orderId']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 70,
                                        ),
                                        // const Padding(
                                        //   padding: EdgeInsets.only(
                                        //     right: 10,
                                        //   ),
                                        //   child: Icon(
                                        //     Icons.arrow_forward_ios,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            getMonthName(show['month'])
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            show['day'].toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${show['weekday']} - ',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                show['time'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            show['artistName'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            show['location'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            Container(
              height: 4,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  color: Color(0xFF0163D5)),
            ),
            const SizedBox(
              height: 50,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _userTicketsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No tickets available');
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data!.map((ticket) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                              child: Text(
                            'Ticket Transfer in Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )),
                          const Center(
                              child: Text('Tickets have been sent to')),
                          Center(child: Text('${ticket['emailPhone']}')),
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Divider(
                              height: 0.5,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: DatabaseHelper.getTicketsByTransferId(
                                ticket['id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text(
                                    'No ticket details available');
                              } else {
                                List<Widget> ticketWidgets = [];
                                for (int i = 0;
                                    i < snapshot.data!.length;
                                    i++) {
                                  final ticketDetails = snapshot.data![i];
                                  ticketWidgets.add(
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'SECTION',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                                '${ticketDetails['selection']}'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'ROW',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text('${ticketDetails['row']}'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'SEAT',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text('${ticketDetails['seat']}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                  if (i < snapshot.data!.length - 1) {
                                    ticketWidgets.add(
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Center(
                                          child: Text(
                                              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -',
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: ticketWidgets,
                                );
                              }
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 46,
                  width: 362,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff0163D5),
                      width: 1.0,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Cancel Transfer',
                      style: TextStyle(
                        color: Color(0xff0163D5),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Positioned(
          top: 150,
          left: 150,
          child: InkWell(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0163D5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFFBFB),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.arrow_outward_sharp,
                size: 24,
                color: Color(0xFFFFFBFB),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  String getMonthName(String month) {
    switch (month) {
      case '01':
        return 'January';
      case '02':
        return 'February';
      case '03':
        return 'March';
      case '04':
        return 'April';
      case '05':
        return 'May';
      case '06':
        return 'June';
      case '07':
        return 'July';
      case '08':
        return 'August';
      case '09':
        return 'September';
      case '10':
        return 'October';
      case '11':
        return 'November';
      case '12':
        return 'December';
      default:
        return '';
    }
  }
}
