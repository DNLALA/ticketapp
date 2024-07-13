import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketapp/pages/ticket/timer.dart';
import 'package:ticketapp/pages/ticket/tranfaruser.dart';
import 'package:ticketapp/pages/ticket/transfarseat.dart';
import 'package:ticketapp/pages/ticket/transfarto.dart';
import 'package:ticketapp/pages/ticket/viewbarcode.dart';
import 'package:ticketapp/services/database_helper.dart';
import 'package:ticketapp/model/datamodel.dart';

class TicketListForShow extends StatefulWidget {
  final int showId;
  final String showData;
  final String date;

  const TicketListForShow(
      {Key? key,
      required this.showId,
      required this.showData,
      required this.date})
      : super(key: key);

  @override
  _TicketListForShowState createState() => _TicketListForShowState();
}

class _TicketListForShowState extends State<TicketListForShow> {
  late Future<List<Map<String, dynamic>>> _ticketListFuture;
  final List<Ticket> _selectedTickets = [];
  int userId = 1;
  bool haveUser = false;
  int myCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTicketsForShow();
  }

  Future<void> _loadTicketsForShow() async {
    final tickets = await DatabaseHelper.getTicketsForShow(widget.showId);
    // Check if any ticket has a transferEmail
    for (var ticket in tickets) {
      if (ticket['transferEmail'] != null) {
        setState(() {
          haveUser = true;
        });
        break; // No need to continue once we find a ticket with transferEmail
      }
    }
    setState(() {
      _ticketListFuture = Future.value(tickets);
      myCurrentIndex = tickets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm');
    // DateFormat format = DateFormat('yyyy-MM-dd HH:mm a');
    DateTime endTime = format.parse(widget.date);
    // DateTime endTime = format.parse('2022-07-9 2:39 PM');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1E272E),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Close the page
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Help',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          )
        ],
        title: const Text(
          'My Ticket',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _ticketListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tickets available'));
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: snapshot.data!.map((ticket) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: screenWidth * 0.9,
                          height: 576,
                          color: const Color(0xFFF3F3F3),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 40,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      color: ticket['transferEmail'] == null
                                          ? const Color(0xFF2E69D7)
                                          : const Color.fromARGB(
                                              255, 157, 162, 166),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ('${ticket['stage']}'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (ticket['stage'] == 'Standard Ticket')
                                    Container(
                                      height: 73,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        color: ticket['transferEmail'] == null
                                            ? const Color(0xFF2E69D7)
                                            : const Color(0xFF576570),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'SEC',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                ticket['selection'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'ROW',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                ticket['row'].toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'SEAT',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                ticket['seat'].toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (ticket['stage'] == 'General Admission')
                                    Container(
                                      height: 73,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        color: ticket['transferEmail'] == null
                                            ? const Color(0xFF2E69D7)
                                            : const Color(0xFF576570),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'SEC',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  ticket['selection'],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              ticket['name'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    height: 201,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      // color: Color.fromARGB(255, 111, 110, 110),
                                      image: DecorationImage(
                                        image:
                                            MemoryImage(ticket['artistImage']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ticket['transferEmail'] == null
                                            ? const SizedBox.shrink()
                                            : Image.asset(
                                                'assets/images/arrow-circle-right_svgrepo.com.png'),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.black,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          width: screenWidth,
                                          child: Column(
                                            children: [
                                              Text(
                                                ticket['artistName'],
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                widget.showData,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox(
                                          height: 10,
                                        )
                                      : Container(
                                          height: 40,
                                          width: screenWidth,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF0163D5),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              ('Sent'),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ticket['transferEmail'] == null
                                      ? ticket['view'] == 'Scheduling Type'
                                          ? const SizedBox(
                                              height: 20,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? ticket['view'] == 'Scheduling Type'
                                          ? const SizedBox(
                                              height: 10,
                                            )
                                          : const SizedBox.shrink()
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? ticket['view'] == 'Scheduling Type'
                                          ? Text(
                                              ('${ticket['fee']}'),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF908E8E),
                                              ),
                                            )
                                          : const Text(
                                              ('Ticket will be ready in:'),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox(
                                          height: 20,
                                        )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? ticket['view'] == 'Scheduling Type'
                                          ? InkWell(
                                              onTap: () {
                                                viewBarcodeBottomSheet(
                                                  context,
                                                  ticket['selection'],
                                                  ticket['ticketType'],
                                                  ticket['row'],
                                                  ticket['seat'],
                                                  ticket['fee'],
                                                  ticket['stage'],
                                                  ticket['artistImage'],
                                                );
                                              },
                                              child: Container(
                                                width: 311,
                                                height: 39,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF2E69D7)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/scanq.png'),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text(
                                                      'View Ticket',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xFFF3F3F3),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : CountdownTimerWidget(
                                              endTime: endTime)
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox(
                                          height: 20,
                                        )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  viewBarcodeBottomSheet(
                                                    context,
                                                    ticket['selection'],
                                                    ticket['ticketType'],
                                                    ticket['row'],
                                                    ticket['seat'],
                                                    ticket['fee'],
                                                    ticket['stage'],
                                                    ticket['artistImage'],
                                                  );
                                                },
                                                child: const Text(
                                                  'Ticket Details',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xFF0163D5)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox(
                                          height: 28,
                                        )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox(
                                          height: 10,
                                        )
                                      : const SizedBox.shrink(),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : const SizedBox(
                                          height: 20,
                                        ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : const Text(
                                          '1 ticket sent to',
                                          style: TextStyle(
                                            color: Color(
                                              0xFF444444,
                                            ),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : Text(
                                          '${ticket['transferEmail']}',
                                          style: const TextStyle(
                                            color: Color(
                                              0xFF908E8E,
                                            ),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : const Text(
                                          'Waiting for recipient to claim.',
                                          style: TextStyle(
                                            color: Color(
                                              0xFF908E8E,
                                            ),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : const SizedBox(
                                          height: 40,
                                        ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : const Text(
                                          'Cancel Transfer',
                                          style: TextStyle(
                                            color: Color(
                                              0xFF0458BA,
                                            ),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ticket['transferEmail'] == null
                                      ? const SizedBox.shrink()
                                      : const SizedBox(
                                          height: 40,
                                        ),
                                  Container(
                                    height: screenHeight * 0.055,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: ticket['transferEmail'] == null
                                          ? const Color.fromARGB(
                                              255, 18, 118, 232)
                                          : const Color(0xFF576570),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'assets/images/tickets_svgrepo.com.png'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          ('ticketmaster.verified'),
                                          style: TextStyle(
                                            color: Color(0xFFF3F3F3),
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < myCurrentIndex; i++)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color.fromARGB(255, 203, 203, 203),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    seatTransBottomSheet(context, _selectedTickets);
                  },
                  child: haveUser == true
                      ? Container(
                          height: screenHeight * 0.055,
                          width: screenWidth * 0.4,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color(0xFFEAEAEA),
                          ),
                          child: const Center(
                            child: Text('Transfer',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        )
                      : Container(
                          height: screenHeight * 0.055,
                          width: screenWidth * 0.4,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color(0xff0163D5),
                          ),
                          child: const Center(
                            child: Text('Transfer',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                ),
                Container(
                  height: screenHeight * 0.055,
                  width: screenWidth * 0.4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xFFEAEAEA),
                  ),
                  child: const Center(
                    child: Text('Sell',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/image 14.png'),
          ),
        ],
      ),
    );
  }

  void viewBarcodeBottomSheet(
    BuildContext context,
    section,
    ticketType,
    row,
    seat,
    door,
    stage,
    artistImage,
  ) {
    showModalBottomSheet<void>(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ViewBarcode(
            section: section,
            showData: widget.showData,
            ticketType: ticketType,
            row: row.toString(),
            seat: seat.toString(),
            door: door.toString(),
            stage: stage.toString(),
            artistImage: artistImage,
          );
        });
  }

  void seatTransBottomSheet(
    BuildContext context,
    List<Ticket> selectedSeats,
  ) {
    showModalBottomSheet<void>(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return TicketSelection(
            eventId: widget.showId,
            seatTransToBottomSheet: seatTransToBottomSheet,
            selectedSeats: selectedSeats.map((ticket) => ticket.id).toList(),
          );
        });
  }

  void seatTransToBottomSheet(
    BuildContext context,
    List<Ticket> selectedSeats,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TransfarTo(
          section: '',
          seatTransBottomSheet: seatTransBottomSheet,
          selectedSeats: selectedSeats.map((ticket) => ticket.id!).toList(),
          seatTransUserBottomSheet: seatTransUserBottomSheet,
        );
      },
    );
  }

  void seatTransUserBottomSheet(
    BuildContext context,
    List<int> selectedSeats,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TransfarUser(
          section: '',
          seatTransBottomSheet: seatTransBottomSheet,
          selectedSeats: selectedSeats,
          userId: userId,
          showId: widget.showId,
          showData: widget.showData,
        );
      },
    );
  }

  // void seatTransUserIdBottomSheet(
  //   BuildContext context,
  //   int userId,
  // ) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     isDismissible: true,
  //     enableDrag: true,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return TransfarSymbol(
  //         userId: userId,
  //       );
  //     },
  //   );
  // }
}
