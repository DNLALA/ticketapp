// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ticketapp/componets/TextFields/BaseText.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticketapp/componets/cards/actioncard.dart';
import 'package:ticketapp/model/datamodel.dart';
import 'package:ticketapp/services/database_helper.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({Key? key}) : super(key: key);

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  late TextEditingController _artistController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _artistController = TextEditingController();
  }

  @override
  void dispose() {
    _artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF127CF7),
        title: const Center(
          child: Text(
            "All Artists",
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
      body: FutureBuilder<List<Artist>>(
        future: DatabaseHelper.getAllArtists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No artists available'));
          } else {
            // Reverse the list of artists
            final reversedArtists = snapshot.data!.reversed.toList();

            return ListView.builder(
              itemCount: (reversedArtists.length / 3)
                  .ceil(), // Calculate number of rows
              itemBuilder: (context, rowIndex) {
                final startIndex = rowIndex * 3;
                final endIndex = (rowIndex + 1) * 3;
                final rowArtists = reversedArtists.sublist(
                    startIndex,
                    endIndex < reversedArtists.length
                        ? endIndex
                        : reversedArtists.length);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rowArtists.map((artist) {
                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 155,
                        width: 126,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 241, 241),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xFF908E8E),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(artist.imageFile),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(artist.name),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ActionContainer(
                                    onTap: () {
                                      if (artist.id != null) {
                                        _deleteArtist(artist.id);
                                      }
                                    },
                                    image: 'assets/images/bin.png',
                                    color: Colors.red,
                                  ),
                                  ActionContainer(
                                    onTap: () {
                                      print('Container clicked!');
                                    },
                                    image: 'assets/images/Pen.png',
                                    color: const Color(0xFF127CF7),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
                  }).toList(),
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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Remove top rounded corners
            ),
            builder: (BuildContext context) {
              return Container(
                height: screenHeight * 0.8,
                width: screenWidth,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Add new artist",
                      style: TextStyle(fontSize: 17),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        controller: _artistController,
                        hintText: 'Enter artist name',
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await _pickImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: screenWidth,
                            height: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFF127CF7), width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _image != null
                                ? Image.file(_image!, fit: BoxFit.cover)
                                : const Icon(
                                    Icons.image,
                                    size: 100,
                                    color: Color(0xFF127CF7),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _addArtist();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF127CF7),
                            ),
                            child: const Text(
                              "Add Artist",
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
        },
        backgroundColor: const Color(0xFF127CF7),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addArtist() async {
    final String artistName = _artistController.text;
    if (artistName.isNotEmpty && _image != null) {
      final Artist artist =
          Artist(name: artistName, imageFile: await _image!.readAsBytes());
      await DatabaseHelper.addArtist(artist);
      setState(() {
        _artistController.clear();
        _image = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artist added successfully')),
      );
      Navigator.pop(context); // Corrected method name
    } else {
      // Show error message if artist name or image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter artist name and select an image'),
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
          title: const Text('Delete Artist'),
          content: const Text('Are you sure you want to delete this artist?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.deleteArtist(id);
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
}
