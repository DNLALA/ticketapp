import 'package:flutter/material.dart';

class TransfarTick extends StatefulWidget {
  final String section;
  const TransfarTick({
    Key? key,
    required this.section,
  }) : super(key: key);

  @override
  State<TransfarTick> createState() => _TransfarTickState();
}

class _TransfarTickState extends State<TransfarTick> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
                    'SELECT SEATS TO TRANSFER',
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
            Text(widget.section),
            Container(
              height: 45,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Color(0xFFEBECED),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('1 seleted'),
                    Row(
                      children: [
                        Text('Transfar To'),
                        Icon(Icons.arrow_forward_ios)
                      ],
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