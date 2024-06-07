import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ticketapp/pages/ticket/tranfaruser.dart';
import 'package:ticketapp/pages/ticket/transfarseat.dart';
import 'package:ticketapp/pages/ticket/transfarto.dart';
import 'package:ticketapp/pages/ticket/viewbarcode.dart';
import 'package:ticketapp/services/database_helper.dart';
import 'package:ticketapp/model/datamodel.dart';

class TicketListForShow extends StatefulWidget {
  final int showId;
  final String showData;

  const TicketListForShow(
      {Key? key, required this.showId, required this.showData})
      : super(key: key);

  @override
  _TicketListForShowState createState() => _TicketListForShowState();
}

class _TicketListForShowState extends State<TicketListForShow> {
  late Future<List<Map<String, dynamic>>> _ticketListFuture;
  final List<Ticket> _selectedTickets = [];
  int userId = 1;
  bool haveUser = false;

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
    });
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
                              Container(
                                height: 40,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  color: ticket['transferEmail'] == null
                                      ? const Color(0xFF0163D5)
                                      : Color.fromARGB(255, 157, 162, 166),
                                ),
                                child: Center(
                                  child: Text(
                                    ('${ticket['ticketType']} Ticket'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 73,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: ticket['transferEmail'] == null
                                      ? const Color.fromARGB(255, 18, 118, 232)
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 201,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  // color: Color.fromARGB(255, 111, 110, 110),
                                  image: DecorationImage(
                                    image: MemoryImage(ticket['artistImage']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ticket['transferEmail'] == null
                                        ? const SizedBox.shrink()
                                        : Image.asset(
                                            'assets/images/arrow-circle-right_svgrepo.com.png'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
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
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                              height:
                                                  5), // Changed from width to height for vertical spacing
                                          Text(
                                            widget.showData,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            20), // Changed from width to height for vertical spacing
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
                                  ? const SizedBox(
                                      height: 20,
                                    )
                                  : const SizedBox.shrink(),
                              ticket['transferEmail'] == null
                                  ? const Text(
                                      'Entry Gate',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              ticket['transferEmail'] == null
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : const SizedBox.shrink(),
                              ticket['transferEmail'] == null
                                  ? Text(
                                      ('ENTER DOOR ${ticket['fee']}'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF908E8E),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              ticket['transferEmail'] == null
                                  ? const SizedBox(
                                      height: 20,
                                    )
                                  : const SizedBox.shrink(),
                              ticket['transferEmail'] == null
                                  ? Image.asset('assets/images/image 12.png')
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
                                            MainAxisAlignment.spaceBetween,
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
                                              );
                                            },
                                            child: const Text(
                                              'View Barcode',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0163D5)),
                                            ),
                                          ),
                                          const Text(
                                            'Ticket Details',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0163D5)),
                                          )
                                        ],
                                      ),
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
                                      ? const Color.fromARGB(255, 18, 118, 232)
                                      : const Color(0xFF576570),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/newgut.png'),
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
          )
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
