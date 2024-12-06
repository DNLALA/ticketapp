import 'package:flutter/material.dart';
import 'package:ticketapp/componets/blanksearch.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/services/database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.25,
            width: screenWidth,
            color: const Color(0xFF0163D5),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  const Row(
                    children: [
                      Text(
                        'Happening live in ',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Greater Los Angeles',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlankSearchContainer(),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFFFFFF),
                              width: 1,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(25, 7, 25, 7),
                            child: Text(
                              'Music',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFFFFFF),
                              width: 1,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(25, 7, 25, 7),
                            child: Text(
                              'Sport',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFFFFFF),
                              width: 1,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(25, 7, 25, 7),
                            child: Text(
                              'Arts, Theater & Comedy',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFFFFFF),
                              width: 1,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(25, 7, 25, 7),
                            child: Text(
                              'Tv Shows',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.26,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nine Inch Nails',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'The Victoria Palace Theatre',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0163D5),
                      border: Border.all(
                        color: const Color(0xFF0163D5),
                        width: 1,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(25, 7, 25, 7),
                      child: Text(
                        'Find Tickets',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.7,
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                            height: 320,
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 249,
                                  width: 393,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        showData[index]['artistImage'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Tickets are on sale now',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        color: Color(0xFF444444)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    show.showName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Color(0xFF444444)),
                                  ),
                                )
                              ],
                            )),
                      );
                    },
                  );
                }
              },
            ),
          ),
          //shows
        ],
      ),
    );
  }
}
