import 'dart:ui';

import 'package:flutter/material.dart';

class TransfarTo extends StatefulWidget {
  final String section;
  final Function seatTransBottomSheet;
  final List<int> selectedSeats;
  final Function seatTransUserBottomSheet;

  const TransfarTo(
      {Key? key,
      required this.section,
      required this.seatTransBottomSheet,
      required this.selectedSeats,
      required this.seatTransUserBottomSheet})
      : super(key: key);

  @override
  State<TransfarTo> createState() => _TransfarToState();
}

class _TransfarToState extends State<TransfarTo> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'TRANSFER TO',
                    style: TextStyle(
                      color: Color(0xFF908E8E),
                      fontSize: 13,
                    ),
                  ),
                  Divider(
                    height: 0.5,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 53,
                width: 388,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.all(Radius.circular(8)),
                  // color: Colors.white,
                  border: Border.all(
                    color: const Color(0xff0163D5),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                ),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select From Contacts',
                        style: TextStyle(
                          color: Color(0xff0163D5),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.contact_page_outlined,
                        color: Color(0xff0163D5),
                      )
                    ]),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                widget.seatTransUserBottomSheet(context, widget.selectedSeats);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 53,
                  width: 388,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(8)),
                    // color: Colors.white,
                    border: Border.all(
                      color: const Color(0xff0163D5),
                      width: 1.0,
                    ),
                  ),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Manually Enter A Recipient',
                          style: TextStyle(
                            color: Color(0xff0163D5),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add_circle_outline,
                          color: Color(0xff0163D5),
                        )
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 38,
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffF6F7F9),
                // border: Border.all(
                //   color: const Color(0xff0163D5),
                //   width: 2.0,
                // ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/Vector (1).png'),
            ),
            const SizedBox(
              height: 38,
            ),
            const Text("Transfer Tickets Via Email or Text Message"),
            const Text("Select an Email or mobile number to"),
            const Text("transfer ticket to your recipient."),
            const SizedBox(
              height: 58,
            ),
            Container(
              height: 45,
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
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // widget.seatTransBottomSheet(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_ios),
                          Text('Back'),
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
    });
  }
}
