import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'login_signup.dart';
import 'dart:math';
import 'user_events_view.dart';
import 'custom_exceptions.dart';

final List<String> dropDownItems = <String>[
  'No Tag',
  'Food',
  'Event',
  'Business'
  
];

class CustomEventsPage extends StatefulWidget {
  const CustomEventsPage({super.key, this.onPostCreated});

  final Function(Post)? onPostCreated;

  @override
  State<CustomEventsPage> createState() => _CustomEventsPageState();
}

class _CustomEventsPageState extends State<CustomEventsPage> {
  
  String? message = null;

  TextEditingController description = TextEditingController();
  String dropDownValue = dropDownItems.first;
  TextEditingController location = TextEditingController();
  TextEditingController title = TextEditingController();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  int _postID = 0;
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  TextEditingController _startTimeController = TextEditingController();
  String _tag = dropDownItems.first;
  

  Future<void> genPostID() async {
    //int postID;
    do {
      _postID = Random().nextInt(2000000000);
      var isUnique = await supabase.from('posts').select('id').eq('id', _postID);
      if (isUnique.isEmpty) {
        break;
      }
    } while (true);
   // return _postID;
  }

  DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  Future<void> _post() async {
    // Await the postID to get the actual integer value
    await genPostID();

    DateTime timeStart = convertTimeOfDayToDateTime(_startTime);
    DateTime timeEnd = convertTimeOfDayToDateTime(_endTime);
    
    // String formattedStart = DateFormat('h:mm a').format(timeStart);
    // String formattedEnd = DateFormat('h:mm a').format(timeEnd);

    try {
      if (timeStart.isAfter(timeEnd)) {
        throw Exception("Throw time exception");
      }
      await supabase.from('posts').insert({
        'id': _postID, // Use the resolved postID here
        'title': title.text,
        'description': description.text,
        'username': getUser().username,
        'date': _dateController.text,
        'start_time': _startTimeController.text,
        'end_time': _endTimeController.text,
        'location': location.text,
        'tag': _tag
      });

      

      
      // Clear inputs after successful insertion
      title.clear();
      description.clear();
      _dateController.clear();
      location.clear();
      _startTimeController.clear();
      _endTimeController.clear();
        

      setState(() {
        message = 'Event Successfully Created!';
      });

      Timer(Duration(seconds: 1), () {
        setState(() {
        message = null;
      });
    });


      }on Exception catch (e) {
        setState(() {
              message = "End time cannot be before start time";
            });
      } catch (error) {
            setState(() {
                  message = "Please don't leave all fields blank!";
            });
    
    }
}

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('MM-dd-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (timeOfDay != null) {
      setState(() {
    
      _startTime = timeOfDay;
      DateTime timeStart = convertTimeOfDayToDateTime(_startTime);
      String formattedStart = DateFormat('h:mm a').format(timeStart);
      _startTimeController.text = formattedStart;

      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _endTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );

    if (timeOfDay != null) {
      setState(() {

      _endTime = timeOfDay;
      DateTime timeEnd = convertTimeOfDayToDateTime(_endTime);
      String formattedEnd = DateFormat('h:mm a').format(timeEnd);
      _endTimeController.text = formattedEnd;

      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.start, 
            children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Custom Events', // Title for the event creation
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: dropDownValue,
                onChanged: (String? value) {
                  setState(() {
                    dropDownValue = value!;
                    _tag = value;
                  });
                },
                items:
                    dropDownItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ), // Spacing between title and button
              const SizedBox(height: 10),
              CustomInputForm(
                  controller: title,
                  icon: Icons.event,
                  label: "Event Name",
                  hint: 'Enter event name',
                  fillColor: Colors.transparent),
              const SizedBox(height: 10),
              CustomInputForm(
                controller: description,
                icon: Icons.description,
                label: 'Description',
                hint: 'Enter event description',
              ),
              const SizedBox(height: 10),

              CustomInputForm(
                  controller: _dateController,
                  icon: Icons.calendar_today,
                  label: 'Date',
                  hint: 'Select a date',
                  readOnly: true,
                  onTap: () => _selectDate(),
                  fillColor: Colors.transparent),
                  
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: _selectStartTime,
                      decoration: InputDecoration(
                        labelText: 'Start',
                        fillColor: Colors.transparent,
                        prefixIcon: Icon(Icons.access_time),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Reduce internal padding
                        isDense: true, 
                        border: OutlineInputBorder(
                           borderSide: BorderSide(
                              color: Color.fromARGB(255, 69, 162, 238), // Set the border color to blue
                              width: 1.5, // Border thickness
                            ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 69, 162, 238), // Border color when focused
                            width: 2, // Slightly thicker when focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                        color: Color.fromARGB(255, 69, 162, 238), // Border color when enabled
                        width: 1.5, // Same thickness as the default border
                        ),
                      ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _endTimeController,
                      readOnly: true,
                      onTap: _selectEndTime,
                      decoration: InputDecoration(
                        labelText: 'End',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Reduce internal padding
                        isDense: true,  
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 69, 162, 238), // Border color when focused
                            width: 2, // Slightly thicker when focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                        color: Color.fromARGB(255, 69, 162, 238), // Border color when enabled
                        width: 1.5, // Same thickness as the default border
                        ),
                      ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomInputForm(
                controller: location,
                icon: Icons.map,
                label: 'Location',
                hint: 'Location',
                fillColor: Colors.transparent,
              ),
              if (message != null) 
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  message!,
                  style: TextStyle(
                    color: message == 'Event Successfully Created!' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  //width: double.infinity,
                  
                  child: ElevatedButton(
                    
                          
                    onPressed: () async {
                      await _post();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(10, 40),
                      side: BorderSide(
                        color: Colors.blue
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                    ),
                    
                    child: Text(
                      'Create Event',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            
            ],

          ),
        )
        )
      );
    
  }
}

//--------------------------------------------------------------------------
// Custom Input Form
//--------------------------------------------------------------------------

class CustomInputForm extends StatelessWidget {
  const CustomInputForm({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.onTap,
    this.fillColor = Colors.transparent,
  });

  final TextEditingController controller;
  final Color fillColor;
  final String hint;
  final IconData icon;
  final String label;
  final GestureTapCallback? onTap;
  final bool readOnly;

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 1.0), // Reduce bottom padding
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 69, 162, 238), // Set the border color to blue
            width: 1.5, // Adjust the border thickness if needed
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 69, 162, 238), // Border color when focused
            width: 2, // Slightly thicker when focused
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 69, 162, 238), // Border color when enabled
            width: 1.5, // Same thickness as the default border
          ),
        ),
        filled: true,
        fillColor: fillColor, // Adjust the background color of the field
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0), // Adjust padding
      ),
    ),
  );
}
}