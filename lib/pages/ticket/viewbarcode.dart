import 'dart:typed_data';
import 'package:flutter/material.dart';

class ViewBarcode extends StatefulWidget {
  final String section;
  final String showData;
  final String ticketType;
  final String row;
  final String seat;
  final String door;
  final String stage;
  final Uint8List artistImage;

  const ViewBarcode({
    Key? key,
    required this.section,
    required this.showData,
    required this.ticketType,
    required this.row,
    required this.seat,
    required this.door,
    required this.stage,
    required this.artistImage,
  }) : super(key: key);

  @override
  State<ViewBarcode> createState() => _ViewBarcodeState();
}

class _ViewBarcodeState extends State<ViewBarcode> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(widget.artistImage),
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: Container(
        color: const Color.fromARGB(175, 6, 6, 6), // Semi-transparent overlay
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top navigation bar
            Container(
              height: screenHeight * 0.085,
              width: screenWidth,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: Color.fromARGB(239, 30, 39, 46),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ticketmaster Event',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          widget.showData,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                Text(
                  '${widget.stage} Ticket',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTicketInfoColumn('SEC', widget.section),
                    _buildTicketInfoColumn('ROW', widget.row),
                    _buildTicketInfoColumn('SEAT', widget.seat),
                  ],
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/gif.gif'),
                const SizedBox(height: 40),
                _buildViewInWalletButton(),
                const SizedBox(height: 40),
                Text(
                  widget.door,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            // Bottom navigation bar
            Container(
              height: screenHeight * 0.085,
              width: screenWidth,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Color(0xFF1E272E),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      '1 of 2',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build ticket info columns
  Widget _buildTicketInfoColumn(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helper function to build the "View in Wallet" button
  Widget _buildViewInWalletButton() {
    return Container(
      width: 133,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF2E69D7),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/goodic.png'),
          const SizedBox(width: 3),
          const Text(
            "View In Wallet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
