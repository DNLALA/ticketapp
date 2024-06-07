// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/pages/ticket/fulltransfar.dart';
import 'package:ticketapp/services/database_helper.dart';

class TransfarUser extends StatefulWidget {
  final String section;
  final Function seatTransBottomSheet;
  final List<int> selectedSeats;
  final int userId;
  final int showId;
  final String showData;

  const TransfarUser({
    Key? key,
    required this.section,
    required this.seatTransBottomSheet,
    required this.selectedSeats,
    required this.userId,
    required this.showId,
    required this.showData,
  }) : super(key: key);

  @override
  State<TransfarUser> createState() => _TransfarUserState();
}

class _TransfarUserState extends State<TransfarUser> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int maxCharacters = 160;
  int _characterCount = 160;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailPhoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void handleTransfer() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String emailPhone = _emailPhoneController.text;
    String note = _noteController.text;

    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        emailPhone.isNotEmpty &&
        note.isNotEmpty) {
      // Create TransferInfo object
      TransferInfo transferInfo = TransferInfo(
        firstName: firstName,
        lastName: lastName,
        emailPhone: emailPhone,
        ticketIds: widget.selectedSeats,
        note: note,
      );
      int transferId = await DatabaseHelper.addTransferInfo(transferInfo);
      print(transferId);
      if (transferId > 0) {
        print(transferId);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransfarSymbol(
              userId: transferId,
              showId: widget.showId,
              showData: widget.showData,
            ),
          ),
        );

        print('Transfer information saved with ID: $transferId');
      } else {
        // If there was an issue saving the transfer information
        print('Failed to save transfer information.');
      }

      // // Clear text fields after transfer
      // _firstNameController.clear();
      // _lastNameController.clear();
      // _emailPhoneController.clear();
      // _noteController.clear();

      // Navigator.pop(context);
    } else {}
  }

  String generateSeatInfo(List<int> selectedSeats) {
    return selectedSeats.map((seat) => 'Seat $seat').join(' & ');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final seatInfo =
        "Sec ${widget.section}, Row Q, ${generateSeatInfo(widget.selectedSeats)}";

    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: screenHeight * 0.7,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'TRANSFER TICKETS',
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
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "${widget.selectedSeats.length.toString()} Ticket Selected",
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  seatInfo,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('First Name'),
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isCollapsed: true,
                        isDense: true,
                        // labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF908E8E)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Last Name'),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        isCollapsed: true,
                        isDense: true,
                        // labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF908E8E),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Email/Phone'),
                    TextField(
                      controller: _emailPhoneController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        isCollapsed: true,
                        isDense: true,
                        // labelText: 'Email/Phone',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF908E8E),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Note'),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        // labelText: 'Note',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(
                            color: Color(0xFF908E8E),
                          ),
                        ),
                      ),
                      maxLength: maxCharacters,
                      maxLines: 3,
                      // Calculate remaining characters dynamically
                      onChanged: (value) {
                        setState(() {
                          // Calculate remaining characters
                          _characterCount = maxCharacters - value.length;
                        });
                      },
                    ), // Add some spacing
                    Text(
                      '$_characterCount Character left',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
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
                          widget.seatTransBottomSheet(
                              context, widget.selectedSeats);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios),
                            Text('Back'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: handleTransfer,
                        child: Container(
                          height: 35,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0163D5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Transfer ${widget.selectedSeats.length.toString()} To',
                                style:
                                    const TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ),
                        ),
                      ),
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
