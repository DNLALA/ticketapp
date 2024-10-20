// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ticketapp/componets/cards/actioncard.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/pages/show/addshow.dart';
import 'package:ticketapp/services/database_helper.dart';

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  late TextEditingController _artistController;

  @override
  void initState() {
    super.initState();
    _artistController = TextEditingController();
    _loadArtists();
  }

  // Function to load artists data
  void _loadArtists() async {
    setState(() {});
  }

  @override
  void dispose() {
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF127CF7),
        title: const Center(
          child: Text(
            "All Shows",
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.getShowsWithArtists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No shows available'));
          } else {
            final List<Map<String, dynamic>> showData = snapshot.data!;
            return ListView.builder(
              itemCount: showData.length,
              itemBuilder: (context, index) {
                final show = Show.fromJson(showData[index]);
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
                    child: Center(
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: CircleAvatar(
                          radius: 27,
                          backgroundImage: MemoryImage(
                            showData[index]['artistImage'],
                          ),
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
                                _deleteArtist(showData[index]['id']);
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
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddShow()),
          );
        },
        backgroundColor: const Color(0xFF127CF7),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteArtist(id) async {
    print(id);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Show'),
          content: const Text('Are you sure you want to delete this show?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.deleteShow(id);
                setState(() {});
                Navigator.of(context).pop();
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
