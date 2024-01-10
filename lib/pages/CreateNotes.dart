import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNotePage extends StatefulWidget {
  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  TextEditingController _noteTextController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String? myuser;
  getUser() async {
    var prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        myuser = user;
      });
    } else {
      setState(() {
        myuser = user;
      });
    }
  }

  Future<void> createNote(String user, String text) async {
    try {
      final apiUrl = Uri.parse(
          'http://localhost:3000/api/notes'); // Replace with your API URL

      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user': user,
          'text': text,
        }),
      );

      if (response.statusCode == 201) {
        // Note created successfully
        final responseData = jsonDecode(response.body);
        print('Note created successfully: ${responseData['message']}');
        Navigator.of(context).pop();
      } else {
        // Error handling
        print('Failed to create note. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors (e.g., network issues)
      print('Error: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Note'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: TextFormField(
                        controller: _noteTextController,
                        scrollController: _scrollController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Text",
                        ),
                        minLines:
                            5, // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Colors.black, // Background color
                    foregroundColor: Colors.white, // Text Color
                  ),
                  onPressed: () {
                    // Implement the logic to create the note here

                    String noteText = _noteTextController.text;
                    createNote(myuser!, noteText);
                    // You can send the noteText to your API or perform the desired action
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
