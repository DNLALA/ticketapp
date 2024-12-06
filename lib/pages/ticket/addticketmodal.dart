import 'package:flutter/material.dart';
import 'package:ticketapp/componets/TextFields/BaseText.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/services/database_helper.dart';

class AddTicketModel extends StatefulWidget {
  const AddTicketModel({Key? key}) : super(key: key);

  @override
  _AddTicketModelState createState() => _AddTicketModelState();
}

class _AddTicketModelState extends State<AddTicketModel> {
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
    _loadShows();
  }

  @override
  void dispose() {
    _sectionController.dispose();
    _rowController.dispose();
    _seatController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _loadShows() async {
    _shows = await DatabaseHelper.getAllShows();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: screenHeight * 0.85,
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "Add new ticket",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Stage Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedStageType,
                  items: ['Standard Ticket', 'General Admission']
                      .map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStageType = newValue;
                      if (newValue == 'Standard Ticket') {
                        _nameController.clear(); // Clear the name field
                      }
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an item' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'View Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedViewType,
                  items:
                      ['Scheduling Type', 'Standard Type'].map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedViewType = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an item' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<Show>(
                  value: _selectedShow,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedShow = newValue;
                    });
                  },
                  items: _shows.map((show) {
                    return DropdownMenuItem<Show>(
                      value: show,
                      child: Text(show.showName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    hintText: 'Select show',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  controller: _sectionController,
                  hintText: 'Section',
                  keyboardType: TextInputType.text,
                ),
              ),
              if (_selectedStageType == 'Standard Ticket')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: _rowController,
                    hintText: 'Row',
                    keyboardType: TextInputType.text,
                  ),
                ),
              if (_selectedStageType == 'Standard Ticket')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: _seatController,
                    hintText: 'Seat',
                    keyboardType: TextInputType.text,
                  ),
                ),
              if (_selectedStageType == 'General Admission')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: _nameController,
                    hintText: 'Name',
                    keyboardType: TextInputType.text,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _addTicket();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF127CF7),
                      ),
                      child: const Text(
                        "Add Ticket",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addTicket() async {
    final String rowName = _sectionController.text;
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
      final result = await DatabaseHelper.addTicket(ticket);
      print(result);
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
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
