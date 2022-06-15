import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

late List<Meeting> meetings;

class _CalendarScreenState extends State<CalendarScreen> {
  List<QueryDocumentSnapshot> requests = [];

  getRequest() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('requests')
        .snapshots()
        .listen((event) {
      List<String> uids = [];
      for (int i = 0; i < event.docs.length; i++) {
        uids.add(event.docs[i].id);
      }
      for (int i = 0; i < uids.length; i++) {
        FirebaseFirestore.instance
            .collection('requests')
            .doc(uids[i])
            .collection('request')
            .where('accepted', isEqualTo: true)
            .where('meeters', arrayContains: userId)
            .snapshots()
            .listen((event) {
          for (int i = 0; i < event.docs.length; i++) {
            requests.add(event.docs[i]);
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequest();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    requests.sort((a, b) {
      DateTime adate = a['ts'].toDate();
      DateTime bdate = b['ts'].toDate();
      return adate.compareTo(bdate);
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xff00AEFF),
                width: 1,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Calendar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff00AEFF),
                        fontSize: w * 6.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: h * 3.8,
          ),
          Expanded(
            child: Container(
              //height: h * 56.1,
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource(requests)),
                cellBorderColor: Colors.white,
                headerHeight: 50,
                onTap: (CalendarTapDetails details) {},
                viewHeaderStyle: ViewHeaderStyle(),
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  agendaItemHeight: 70,
                  appointmentDisplayCount: requests.length,
                  showTrailingAndLeadingDates: false,
                  numberOfWeeksInView: 4,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

List<Meeting> _getDataSource(List<QueryDocumentSnapshot> requests) {
  meetings = <Meeting>[];
  for (int i = 0; i < requests.length; i++) {
    /*final DateTime startTime = DateTime(
        DateTime.parse(requests[i]['date']).year,
        DateTime.parse(requests[i]['date']).month,
        DateTime.parse(requests[i]['date']).day,
        requests[i]['startTime']['hour'],
        requests[i]['startTime']['min'],
        0);*/
    final DateTime startDateTime = requests[i]['startDateTime'].toDate();
    final DateTime endDateTime = requests[i]['endDateTime'].toDate();

    /*final DateTime endTime =
        startTime.add(Duration(minutes: requests[i]['duration']));*/
    meetings.add(Meeting(requests[i]['title'], startDateTime, endDateTime,
        const Color(0xFF0F8644), false));
  }
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
