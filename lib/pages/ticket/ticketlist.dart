// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ticketapp/componets/cards/actioncard.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/pages/ticket/addticketmodal.dart';
import 'package:ticketapp/services/database_helper.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  late TextEditingController _sectionController;
  late TextEditingController _rowController;
  late TextEditingController _seatController;
  late TextEditingController _nameController;
  late List<Show> _shows;
  String? _selectedStageType;
  String? _selectedViewType;
  Show? _selectedShow;

  @override
  void initState() {
    super.initState();
    _sectionController = TextEditingController();
    _rowController = TextEditingController();
    _seatController = TextEditingController();
    _nameController = TextEditingController();
    _selectedShow = null;
    _loadArtists();
  }

  void _loadArtists() async {
    _shows = await DatabaseHelper.getAllShows();
    setState(() {});
  }

  @override
  void dispose() {
    _sectionController.dispose();
    _rowController.dispose();
    _seatController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF127CF7),
        title: const Center(
          child: Text(
            "All Tickets",
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.getTicketsWithShowsAndArtists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tickets available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                print(snapshot.data![index]);
                final ticketData = snapshot.data![index];
                final show = Show.fromJson(ticketData);
                final artistName = ticketData['artistName'];
                final artistImageBytes = ticketData['artistImage'];
                final sec = ticketData['selection'];
                final seat = ticketData['seat'];
                final row = ticketData['row'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 98,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 243, 241, 241),
                      boxShadow: [
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
                        Center(
                          child: ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            leading: CircleAvatar(
                              radius: 27,
                              backgroundImage: MemoryImage(
                                  Uint8List.fromList(artistImageBytes)),
                            ),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getMonthName(show.month),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      show.day.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      show.time,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      show.location,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ActionContainer(
                                  onTap: () {
                                    _deleteArtist(ticketData['ticketId']);
                                  },
                                  image: 'assets/images/bin.png',
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                ActionContainer(
                                  onTap: () {
                                    print('Container clicked!');
                                  },
                                  image: 'assets/images/Pen.png',
                                  color: const Color(0xFF127CF7),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SEC ${sec.toString()}'),
                              Text('ROW ${row.toString()}'),
                              Text('SEAT ${seat.toString()}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            enableDrag: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return const AddTicketModel();
            },
          );
        },
        backgroundColor: const Color(0xFF127CF7),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTicket() async {
    final String rowName = _rowController.text;
    if (rowName.isNotEmpty) {
      final Ticket ticket = Ticket(
        showId: _selectedShow!.id,
        stage: _selectedStageType ?? '',
        view: _selectedViewType ?? '',
        selection: _sectionController.text,
        row: _rowController.text,
        seat: _seatController.text,
        name: _nameController.text,
      );
      await DatabaseHelper.addTicket(ticket); // Corrected method call
      setState(() {
        _sectionController.clear();
        _rowController.clear();
        _seatController.clear();
        _nameController.clear();
        _selectedStageType = null;
        _selectedViewType = null;
        _selectedShow = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket added successfully')),
      );
      Navigator.pop(context); // Corrected method name
    } else {
      // Show error message if row name is not entered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteArtist(id) async {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ticket'),
          content: const Text(
            'Are you sure you want to delete this Ticket?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.deleteTicket(id); // Corrected method call
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
