import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], 
      ),
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final player = AudioPlayer(); 
  String selectedDay = 'Monday';
  String selectedActivity = 'Wake up';
  TimeOfDay selectedTime = TimeOfDay.now();

  // Dropdown list options
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep'
  ];

  void scheduleReminder() {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    if (reminderDateTime.isBefore(now)) {
      final tomorrow = now.add(const Duration(days: 1));
      scheduleReminderForDate(DateTime(tomorrow.year, tomorrow.month,
          tomorrow.day, selectedTime.hour, selectedTime.minute));
    } else {
      scheduleReminderForDate(reminderDateTime);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reminder Set"),
          content: Text(
              "Reminder for $selectedActivity on $selectedDay at ${selectedTime.format(context)} has been set."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void scheduleReminderForDate(DateTime reminderDateTime) {
    final now = DateTime.now();
    final durationUntilReminder = reminderDateTime.difference(now);

    Future.delayed(durationUntilReminder, () {
      playSound();
    });
  }

  void playSound() async {
    await player.play('assets/sounds/chime.mp3'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), 
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5, 
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Reminder App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color:  Color.fromARGB(255, 37, 38, 40), 
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        
                          color: const Color.fromARGB(255, 37, 38, 40), width: 2),
                    ),
                    child: DropdownButton<String>(
                      value: selectedDay,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: daysOfWeek.map((String day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (String? newDay) {
                        setState(() {
                          selectedDay = newDay!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16), 
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2, 
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 37, 38, 40), width: 2), 
                    ),
                    child: DropdownButton<String>(
                      value: selectedActivity,
                      isExpanded: true,
                      underline: const SizedBox(), 
                      items: activities.map((String activity) {
                        return DropdownMenuItem<String>(
                          value: activity,
                          child: Text(activity),
                        );
                      }).toList(),
                      onChanged: (String? newActivity) {
                        setState(() {
                          selectedActivity = newActivity!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24), 
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 154, 188, 239), 
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), 
                    ),
                    child: Text("Select Time"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      scheduleReminder();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 143, 235, 240), 
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), 
                    ),
                    child: Text("Set Reminder"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
