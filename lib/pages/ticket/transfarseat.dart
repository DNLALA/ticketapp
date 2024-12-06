import 'package:flutter/material.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/services/database_helper.dart';

class TicketSelection extends StatefulWidget {
  final int eventId;
  final Function seatTransToBottomSheet;
  final selectedSeats;

  const TicketSelection(
      {Key? key,
      required this.eventId,
      required this.seatTransToBottomSheet,
      required this.selectedSeats})
      : super(key: key);

  @override
  State<TicketSelection> createState() => _TicketSelectionState();
}

class _TicketSelectionState extends State<TicketSelection> {
  late Future<List<Ticket>> _ticketsFuture;
  final List<Ticket> _selectedTickets = [];

  @override
  void initState() {
    super.initState();
    _loadTicketsForShow();
  }

  Future<void> _loadTicketsForShow() async {
    setState(() {
      _ticketsFuture = _getTicketsForShow();
    });
  }

  Future<List<Ticket>> _getTicketsForShow() async {
    final List<Map<String, dynamic>> ticketsData =
        await DatabaseHelper.getTicketsForShow(widget.eventId);
    return ticketsData
        .map((ticketData) => Ticket.fromJson(ticketData))
        .toList();
  }

  void _toggleTicketSelection(Ticket ticket) {
    setState(() {
      if (_selectedTickets.contains(ticket)) {
        _selectedTickets.remove(ticket);
      } else {
        _selectedTickets.add(ticket);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Ticket>>(
      future: _ticketsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading tickets'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tickets available'));
        }

        final tickets = snapshot.data!;

        return SizedBox(
          height: screenHeight * 0.6,
          width: screenWidth,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align everything to the top-left
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'SELECT SEATS TO TRANSFER',
                      style: TextStyle(
                        color: Color(0xFF908E8E),
                        fontSize: 13,
                      ),
                    ),
                    const Divider(
                      height: 0.5,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Transform.rotate(
                              angle:
                                  2, // Horizontal orientation (no rotation needed by default)
                              child: const Icon(
                                Icons.confirmation_number,
                                color: Color(0xFF908E8E),
                                size: 15,
                              ),
                            ), // Add some spacing between the icon and the text
                            Text(
                              '${tickets.length.toString()} tickets',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFF908E8E),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Ticket>>(
                  future: _ticketsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final tickets = snapshot.data;
                      if (tickets == null || tickets.isEmpty) {
                        return const Center(
                            child: Text('No tickets available'));
                      }
                      return Wrap(
                        spacing: 10, // Horizontal spacing between cards
                        runSpacing: 10, // Vertical spacing between rows
                        alignment: WrapAlignment
                            .start, // Ensure wrapping starts from left
                        children: tickets.map((ticket) {
                          final isSelected = _selectedTickets
                              .contains(ticket); // Check if ticket is selected
                          return GestureDetector(
                            onTap: () => _toggleTicketSelection(ticket),
                            child: Container(
                              width: 108, // Fixed width for the card
                              height: 109, // Fixed height for the card
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF908E8E),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 31,
                                    width:
                                        108, // Same width for the top container
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      color: Color(0xFF0163D5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'SEAT ${ticket.seat}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 78,
                                    width:
                                        108, // Same width for the icon container
                                    child: Center(
                                      child: Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: isSelected
                                            ? Colors.blue
                                            : const Color(0xFF908E8E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
              // Spacer is used to push the button to the bottom
              Spacer(),
              // Footer with the "Transfer To" button
              Container(
                height: 50,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Color(0xFFEBECED),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_selectedTickets.length} selected'),
                      InkWell(
                        onTap: () {
                          if (_selectedTickets.isNotEmpty) {
                            for (Ticket ticket in _selectedTickets) {
                              print('Selected Ticket: ${ticket.toJson()}');
                            }
                            Navigator.pop(context);
                            print(_selectedTickets);
                            widget.seatTransToBottomSheet(
                                context, _selectedTickets);
                          }
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Transfer To',
                              style: TextStyle(
                                  color: Color(0xFF0163D5),
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF0163D5)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
