import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketapp/componets/TextFields/BaseText.dart';
import 'package:ticketapp/componets/TextFields/TextFieldDecoration.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/services/database_helper.dart';

class AddShow extends StatefulWidget {
  const AddShow({super.key});

  @override
  State<AddShow> createState() => _AddShowState();
}

class _AddShowState extends State<AddShow> {
  late TextEditingController _showName;
  late TextEditingController _showLocation;
  late TextEditingController _entryGate;
  late TextEditingController _orderID;
  late TextEditingController _mapURL;
  late TextEditingController _ticketType;
  late List<Artist> _artists;
  Artist? _selectedArtist;

  @override
  void initState() {
    super.initState();
    _loadArtists();
    _showName = TextEditingController();
    _showLocation = TextEditingController();
    _entryGate = TextEditingController();
    _orderID = TextEditingController();
    _mapURL = TextEditingController();
    _ticketType = TextEditingController();
    _artists = [];
  }

  // Function to load artists data
  void _loadArtists() async {
    _artists = await DatabaseHelper.getAllArtists();
    setState(() {}); // Update state to rebuild UI with loaded artists
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _showName.dispose();
    _showLocation.dispose();
    _entryGate.dispose();
    _orderID.dispose();
    _mapURL.dispose();
    _ticketType.dispose();
    super.dispose();
  }

  // Get the weekday as a string (e.g., 'Mon', 'Tue')
  String _getWeekdayString(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add new show",
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown to select artist
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Artist>(
                value: _selectedArtist,
                onChanged: (newValue) {
                  setState(() {
                    _selectedArtist = newValue;
                  });
                },
                items: _artists.map((artist) {
                  return DropdownMenuItem<Artist>(
                    value: artist,
                    child: Text(artist.name),
                  );
                }).toList(),
                decoration: inputDecoration(
                  context,
                  hintText: 'Select artist',
                ),
              ),
            ),
            // Date and time pickers
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: TextEditingController(
                  text:
                      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                ),
                decoration: inputDecoration(
                  context,
                  hintText: 'Select date',
                  suffixIcon: Image.asset('assets/images/Calendar.png'),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: TextEditingController(
                  text: _getWeekdayString(_selectedDate),
                ),
                decoration: inputDecoration(
                  context,
                  hintText: 'Weekday',
                  suffixIcon: Image.asset('assets/images/Calendar.png'),
                ),
                readOnly: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: TextEditingController(
                  text: _selectedTime.format(context),
                ),
                decoration: inputDecoration(
                  context,
                  hintText: 'Select time',
                  suffixIcon: Image.asset('assets/images/Clock.png'),
                ),
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (pickedTime != null && pickedTime != _selectedTime) {
                    setState(() {
                      _selectedTime = pickedTime;
                    });
                  }
                },
              ),
            ),
            // Text fields for show details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _showName,
                hintText: 'Show name',
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _showLocation,
                hintText: 'Show location',
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _entryGate,
                hintText: 'Entry Gate',
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _orderID,
                hintText: 'Order ID',
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _mapURL,
                hintText: 'Map Url',
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                controller: _ticketType,
                hintText: 'Ticket Type',
                keyboardType: TextInputType.text,
              ),
            ),
            // Button to add show
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _addShow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF127CF7),
                ),
                child: const Text(
                  "Add Show",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addShow() async {
    final String showName = _showName.text;
    final String month = _selectedDate.month.toString().padLeft(2, '0');
    final String day = _selectedDate.day.toString().padLeft(2, '0');
    final String weekday = _getWeekdayString(_selectedDate);
    final String time = _selectedTime.format(context);
    print(weekday);
    print(weekday);
    print('weekday');

    if (showName.isNotEmpty && _selectedArtist != null) {
      final Show show = Show(
        showName: showName,
        artistId: _selectedArtist!.id,
        month: month,
        day: int.parse(day),
        weekday: weekday, // Add the weekday to the Show object
        time: time,
        location: _showLocation.text,
        fee: _entryGate.text,
        orderId: _orderID.text,
        mapUrl: _mapURL.text,
        ticketType: _ticketType.text,
      );
      await DatabaseHelper.addShow(show);
      setState(() {
        _showName.clear(); // Clear show name controller
        _showLocation.clear(); // Clear show location controller
        _entryGate.clear(); // Clear entry gate controller
        _orderID.clear(); // Clear order ID controller
        _mapURL.clear(); // Clear map URL controller
        _ticketType.clear(); // Clear ticket type controller
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Show added successfully')),
      );
      Navigator.pop(context); // Pop current screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter show name and select an artist'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
