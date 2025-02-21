import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitDetailsPage extends StatelessWidget {
  const HabitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.penClip),
            color: Theme.of(context).colorScheme.secondary,
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.trashCan,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meditation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'Meditate as  often as everyday if possible without fail',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.repeat,
                        size: 40,
                        color: Colors.green,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Repeat',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Daily',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.flagCheckered,
                        size: 40,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Completed',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '10 Days',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepOrange,
                            ),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Streak',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '10 days',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Your Longest Streak',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        child: FaIcon(
                      FontAwesomeIcons.boltLightning,
                      size: 80,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.now().subtract(Duration(days: 10)),
                lastDay: DateTime.now().add(Duration(days: 730)),
                headerVisible: false,
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
