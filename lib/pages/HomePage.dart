import 'package:codenotes/pages/CreateNotes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List notes = [];

  fetchNotes() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/notes'));
    if (response.statusCode == 200) {
      setState(() {
        Map data = json.decode(response.body);
        notes = data['notes'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  deleteNotes(String id) async {
    print(id);
    try {
      final apiUrl = Uri.parse(
          'http://localhost:3000/api/notes/${id}'); // Replace with your API URL
      final response = await http.delete(apiUrl);

      if (response.statusCode == 200) {
        // Note deleted successfully
        fetchNotes(); // Fetch data again after successful delete
      } else {
        print('Failed to delete note. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset(
          'assets/images/notes.png',
          width: 200,
        ),
        leadingWidth: 200,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => CreateNotePage()))
                    .then((value) => fetchNotes());
              },
              child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.create,
                      color: Colors.white) // First letter of the user's name
                  ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount:
            notes.length, // Number of cards, replace with your data length
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          0.15), // Blackish shadow with transparency
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${notes[index]['user']}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${notes[index]['createdAt'].substring(0, 10)}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    deleteNotes(notes[index]['_id']);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Shortened  gfdg sdfgfds gfds gfdsg df s fdsf dsf sd fdsf ds fsdfdsdf fdsf dsfdsf dsfsdf sdfsdf s fsd dfsaf dsaf ads fdsfB fa fdsaf asf sdaf asf asdf dsa dsody Text', // Replace with actual text
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
